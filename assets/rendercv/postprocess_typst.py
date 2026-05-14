#!/usr/bin/env python3
"""Apply local layout tweaks to the Typst file emitted by RenderCV."""

from __future__ import annotations

import re
import sys
from pathlib import Path


HEADER_RE = re.compile(
    r"""
    \n=\s+(?P<name>[^\n]+)
    \n\n\s+\#headline\(\[(?P<headline>.*?)\]\)
    \n\n\#connections\(
    (?P<connections>.*?)
    \n\)
    \n\n
    """,
    re.DOTALL | re.VERBOSE,
)

TYPST2_HEADER_RE = re.compile(
    r"""
    \n=\s+(?P<name>[^\n]+)
    \n\n//\ Print\ connections:
    \n\#let\ connections-list\ =\ \(
    (?P<connections>.*?)
    \n\)
    \n\#connections\(connections-list\)
    \n\n+
    """,
    re.DOTALL | re.VERBOSE,
)

CONNECTION_RE = re.compile(
    r"""
    ^\s*
    (?:
      \[\#link\("(?P<url>[^"]+)"[^\]]*\)\[(?P<link_label>[^:\]]+):\s*(?P<link_value>.*?)\]\]
      |
      \[(?P<label>[^:\]]+):\s*(?P<value>.*?)\]
    )
    ,?\s*$
    """,
    re.VERBOSE,
)


def load_cv_data(path: Path | None) -> dict:
    if path is None or not path.exists():
        return {}

    import yaml

    return yaml.safe_load(path.read_text()).get("cv", {})


def parse_connections(connections: str) -> dict[str, tuple[str | None, str]]:
    parsed: dict[str, tuple[str | None, str]] = {}
    for line in connections.splitlines():
        match = CONNECTION_RE.match(line)
        if not match:
            continue

        label = match.group("link_label") or match.group("label")
        value = match.group("link_value") or match.group("value")
        parsed[label] = (match.group("url"), value)

    return parsed


def typst_link(url: str | None, text: str) -> str:
    if url:
        return f'[#link("{url}")[{text}]]'
    return f"[{text}]"


def contact_section_from_values(
    name: str,
    headline: str,
    email: str,
    website: str,
    linkedin_username: str | None,
    github_username: str | None,
) -> str:
    escaped_email = email.replace("@", r"\@")
    website_display = website.removeprefix("https://").removeprefix("http://").removesuffix("/")

    rows = [("Name", f"[{name}]")]
    if headline:
        rows.append(("Professional Title", f"[{headline}]"))

    if email:
        rows.append(("Email", typst_link(f"mailto:{email}", escaped_email)))
    if website:
        rows.append(("Website", typst_link(website, website_display)))
    if github_username:
        rows.append(
            (
                "GitHub",
                typst_link(
                    f"https://github.com/{github_username}",
                    f"github.com/{github_username}",
                ),
            )
        )
    if linkedin_username:
        rows.append(
            (
                "LinkedIn",
                typst_link(
                    f"https://www.linkedin.com/in/{linkedin_username}",
                    f"linkedin.com/in/{linkedin_username}",
                ),
            )
        )

    row_markup = "\n".join(f"  [#strong[{label}]], {value}," for label, value in rows)

    return (
        "\n== Contact Information\n\n"
        "#grid(\n"
        "  columns: (3.8cm, 1fr),\n"
        "  column-gutter: 0.8cm,\n"
        "  row-gutter: 0.18cm,\n"
        f"{row_markup}\n"
        ")\n\n"
    )


def contact_section(match: re.Match[str]) -> str:
    name = match.group("name")
    headline = match.groupdict().get("headline") or ""
    connections = parse_connections(match.group("connections"))

    email = ""
    if "Email" in connections:
        _, email = connections["Email"]
        email = email.replace(r"\@", "@")

    linkedin_username = None
    if "LinkedIn" in connections:
        _, linkedin_username = connections["LinkedIn"]
        linkedin_username = linkedin_username.replace(r"\/", "/").removeprefix(
            "linkedin.com/in/"
        )

    github_username = None
    if "GitHub" in connections:
        _, github_username = connections["GitHub"]
        github_username = github_username.replace(r"\/", "/").removeprefix("github.com/")

    return contact_section_from_values(
        name,
        headline,
        email,
        "",
        linkedin_username,
        github_username,
    )


def contact_section_from_cv(cv: dict) -> str:
    socials = {
        social.get("network", "").lower(): social.get("username")
        for social in cv.get("social_networks", [])
    }

    return contact_section_from_values(
        cv.get("name", ""),
        cv.get("headline") or cv.get("label", ""),
        cv.get("email", ""),
        cv.get("website", ""),
        socials.get("linkedin"),
        socials.get("github"),
    )


def postprocess(path: Path, cv_path: Path | None = None) -> None:
    content = path.read_text()
    cv = load_cv_data(cv_path)

    if cv:
        section = contact_section_from_cv(cv)
        content, replacements = HEADER_RE.subn(section, content, count=1)
        if replacements == 0:
            content, replacements = TYPST2_HEADER_RE.subn(section, content, count=1)
    else:
        content, replacements = HEADER_RE.subn(contact_section, content, count=1)
        if replacements == 0:
            content, replacements = TYPST2_HEADER_RE.subn(contact_section, content, count=1)

    if replacements == 0 and "== Contact Information" in content:
        replacements = 1
    if replacements != 1:
        raise RuntimeError("Could not find the RenderCV header block to rewrite.")

    content = content.replace("\n== Summary\n", "\n== Professional Summary\n", 1)
    path.write_text(content)


def compile_pdf(typst_path: Path, pdf_path: Path) -> None:
    import typst

    typst.compile(typst_path, output=pdf_path)


def main() -> int:
    args = sys.argv[1:]
    if not args:
        print(
            "Usage: postprocess_typst.py PATH_TO_RENDERED_TYPST [--cv PATH_TO_CV_YAML] [--pdf PATH_TO_PDF]",
            file=sys.stderr,
        )
        return 2

    typst_path = Path(args.pop(0))
    cv_path = None
    pdf_path = None

    while args:
        flag = args.pop(0)
        if not args:
            print(f"Missing value for {flag}", file=sys.stderr)
            return 2
        value = Path(args.pop(0))
        if flag == "--cv":
            cv_path = value
        elif flag == "--pdf":
            pdf_path = value
        else:
            print(f"Unknown option: {flag}", file=sys.stderr)
            return 2

    postprocess(typst_path, cv_path)

    if pdf_path:
        compile_pdf(typst_path, pdf_path)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
