// Import the rendercv function and all the refactored components
#import "@preview/rendercv:0.3.0": *

// Apply the rendercv template with custom configuration
#show: rendercv.with(
  name: "Kamil Mikolaj",
  title: "Kamil Mikolaj - CV",
  footer: context { [#emph[Kamil Mikolaj -- #str(here().page())\/#str(counter(page).final().first())]] },
  top-note: [ #emph[Last updated in Apr 2026] ],
  locale-catalog-language: "en",
  text-direction: ltr,
  page-size: "a4",
  page-top-margin: 0.7in,
  page-bottom-margin: 0.7in,
  page-left-margin: 0.7in,
  page-right-margin: 0.7in,
  page-show-footer: false,
  page-show-top-note: false,
  colors-body: rgb(0, 0, 0),
  colors-name: rgb(0, 79, 144),
  colors-headline: rgb(0, 79, 144),
  colors-connections: rgb(0, 79, 144),
  colors-section-titles: rgb(0, 79, 144),
  colors-links: rgb(0, 79, 144),
  colors-footer: rgb(128, 128, 128),
  colors-top-note: rgb(128, 128, 128),
  typography-line-spacing: 0.6em,
  typography-alignment: "justified",
  typography-date-and-location-column-alignment: right,
  typography-font-family-body: "Source Sans 3",
  typography-font-family-name: "Source Sans 3",
  typography-font-family-headline: "Source Sans 3",
  typography-font-family-connections: "Source Sans 3",
  typography-font-family-section-titles: "Source Sans 3",
  typography-font-size-body: 10pt,
  typography-font-size-name: 30pt,
  typography-font-size-headline: 10pt,
  typography-font-size-connections: 10pt,
  typography-font-size-section-titles: 1.4em,
  typography-small-caps-name: false,
  typography-small-caps-headline: false,
  typography-small-caps-connections: false,
  typography-small-caps-section-titles: false,
  typography-bold-name: true,
  typography-bold-headline: false,
  typography-bold-connections: false,
  typography-bold-section-titles: true,
  links-underline: false,
  links-show-external-link-icon: false,
  header-alignment: center,
  header-photo-width: 3.5cm,
  header-space-below-name: 0.7cm,
  header-space-below-headline: 0.7cm,
  header-space-below-connections: 0.7cm,
  header-connections-hyperlink: true,
  header-connections-show-icons: true,
  header-connections-display-urls-instead-of-usernames: false,
  header-connections-separator: "",
  header-connections-space-between-connections: 0.5cm,
  section-titles-type: "with_partial_line",
  section-titles-line-thickness: 0.5pt,
  section-titles-space-above: 0.5cm,
  section-titles-space-below: 0.3cm,
  sections-allow-page-break: true,
  sections-space-between-text-based-entries: 0.3em,
  sections-space-between-regular-entries: 1.2em,
  entries-date-and-location-width: 4.15cm,
  entries-side-space: 0.2cm,
  entries-space-between-columns: 0.1cm,
  entries-allow-page-break: false,
  entries-short-second-row: true,
  entries-degree-width: 1cm,
  entries-summary-space-left: 0cm,
  entries-summary-space-above: 0cm,
  entries-highlights-bullet:  "•" ,
  entries-highlights-nested-bullet:  "•" ,
  entries-highlights-space-left: 0.15cm,
  entries-highlights-space-above: 0cm,
  entries-highlights-space-between-items: 0cm,
  entries-highlights-space-between-bullet-and-text: 0.5em,
  date: datetime(
    year: 2026,
    month: 4,
    day: 26,
  ),
)


= Kamil Mikolaj

  #headline([Machine Learning Engineer])

#connections(
  [#link("mailto:kmikol.public@icloud.com", icon: false, if-underline: false, if-color: false)[#connection-with-icon("envelope")[kmikol.public\@icloud.com]]],
  [#connection-with-icon("location-dot")[Copenhagen, Denmark]],
  [#link("https://github.com/kmikol", icon: false, if-underline: false, if-color: false)[#connection-with-icon("github")[kmikol]]],
  [#link("https://linkedin.com/in/kamilmikolaj", icon: false, if-underline: false, if-color: false)[#connection-with-icon("linkedin")[kamilmikolaj]]],
  [#link("https://scholar.google.com/citations?user=u3P6_bEAAAAJ", icon: false, if-underline: false, if-color: false)[#connection-with-icon("graduation-cap")[Google Scholar]]],
)


== Summary

ML engineer with a track record of owning systems end-to-end across MLOps, computer vision, and 3D reconstruction. Comfortable at every layer of the stack — from C++ to Kubernetes-based retraining pipelines. Background in a domain where evaluation rigour and data quality aren't optional, which shapes how I approach production ML generally.

== Experience

#regular-entry(
  [
    #strong[Dalux], Machine Learning and Computer Vision Engineer

    #summary[Applying ML and computer vision to BIM and construction site understanding — building production systems across data pipelines, model training, and inference, with visibility into cloud deployment (AWS, Kubernetes, Argo) and monitoring (Prometheus\/Grafana).]

  ],
  [
    Copenhagen

    Nov 2025 – present

    

    6 months

  ],
)

#regular-entry(
  [
    #strong[GE Healthcare], Visiting Researcher

    #summary[Research and optimization of motion-compensated 3D ultrasound reconstruction for laparoscopic liver workflows.]

    - Targeted sub-minute runtime per sequence.

  ],
  [
    Herlev

    Jan 2025 – Mar 2025

    

    2 months

  ],
)

#regular-entry(
  [
    #strong[Technical University of Denmark (DTU)], PhD Student

    #summary[End-to-end ML\/CV research in obstetric ultrasound in collaboration with Rigshospitalet.]

    - Technical lead for 3D reconstruction, fetal-growth modeling, heart segmentation, and analysis.

    - Cut training time by 3x at matched quality for a 3D ultrasound reconstruction pipeline. #link("https://link.springer.com/chapter/10.1007/978-3-031-95911-0_27")[Publication]

    - Built an automated large-scale ultrasound pipeline for image-based fetal growth regression.

    - Reduced measurement error by 13\% versus current clinical practice. #link("https://www.nature.com/articles/s41746-025-01704-0")[Publication]

    - Contributed to two UK patents. #link("https://www.ipo.gov.uk/p-ipsum/Case/PublicationNumber/GB2636227")[Granted], #link("https://www.ipo.gov.uk/p-ipsum/Case/PublicationNumber/GB2636226")[Pending]

    - Built a heart segmentation model with end-user input and deployed a real-time tablet prototype.

  ],
  [
    Kongens Lyngby

    Aug 2022 – Oct 2025

    

    3 years 3 months

  ],
)

#regular-entry(
  [
    #strong[SPS - Specialpaedagogisk Stotte], Pedagogical Support Teacher, Part-time

    #summary[Providing academic and mentoring support to students with special educational needs.]

  ],
  [
    Kongens Lyngby

    Apr 2024 – Dec 2025

    

    1 year 9 months

  ],
)

#regular-entry(
  [
    #strong[Copenhagen Academy for Medical Education and Simulation (CAMES)], Research Assistant, Part-time

    #summary[Collaborative work between DTU and Rigshospitalet on ML in obstetric ultrasound.]

    - Contributed to data preprocessing, fetal growth prediction, and multi-institutional project coordination.

  ],
  [
    Copenhagen

    June 2021 – June 2022

    

    1 year 1 month

  ],
)

== Education

#education-entry(
  [
    #strong[Technical University of Denmark (DTU)], Applied Mathematics and Computer Science (Visual Computing)

    - Thesis: From Automated 2D Analysis to 3D Reconstruction: Advancing Ultrasound Imaging with AI-Driven Methods. #link("https://orbit.dtu.dk/en/publications/from-automated-2d-analysis-to-3d-reconstruction-advancing-ultraso/")[Download]

    - #link("/assets/grade_transcripts/PhD%20Grades%20Transcript.pdf")[Courses]

  ],
  [
    Kongens Lyngby

    Aug 2022 – Oct 2025

  ],
  degree-column: [
    #strong[PhD]
  ],
)

#education-entry(
  [
    #strong[Technical University of Denmark (DTU)], Autonomous Systems Engineering (Honours Programme)

    - Thesis: Automatic Detection of Anatomical Structures in Fetal Hearts.

    - #link("/assets/grade_transcripts/MSc%20Grade%20Transcript.pdf")[Courses]

  ],
  [
    Kongens Lyngby

    Sept 2020 – June 2022

  ],
  degree-column: [
    #strong[MSc]
  ],
)

#education-entry(
  [
    #strong[Aalborg University (AAU)], Electronics and Computer Engineering

    - Thesis: Deep Neural Network Trained on Synthetic Dataset for Quadcopter Navigation. #link("https://vbn.aau.dk/ws/portalfiles/portal/559754247/EfficientNavigationCNN_CODIT23.pdf")[Publication]

  ],
  [
    Aalborg, Denmark

    Sept 2017 – June 2020

  ],
  degree-column: [
    #strong[BSc]
  ],
)

== Skills

#strong[Modelling:] Deep Learning, Segmentation, 3D Reconstruction, NeRF, Semi-supervised Learning, Unsupervised Learning, Classification

#strong[Engineering:] Python, C\/C++, Systems Design, Inference Optimization, API Design

#strong[Infrastructure:] MLOps, Cloud Deployment, Workflow Orchestration, Monitoring, Containerization

#strong[Data:] Pipeline Design, Annotation, Dataset Curation, Data Quality Assurance

#strong[Computer Vision:] Image Processing, Image Analysis, 3D Reconstruction

== Tools

#strong[ML Frameworks:] PyTorch, OpenCV, scikit-learn

#strong[Infrastructure & Cloud:] AWS, Kubernetes, Docker, Argo Workflows, Argo Rollouts

#strong[Monitoring & Observability:] Prometheus, Grafana, Loki

#strong[MLOps:] MLflow, ONNX, Helm

#strong[Languages:] Python, C\/C++, MATLAB, LaTeX

== Awards

#regular-entry(
  [
    #strong[UK Patent Application GB2636226]

    #summary[A method of, and apparatus for, improved estimation of fetal characteristics.]

  ],
  [
    2023

  ],
)

#regular-entry(
  [
    #strong[UK Patent Application GB2636227]

    #summary[An improved method of, and apparatus for, ultrasound examination to extract fetal characteristics.]

  ],
  [
    2023

  ],
)
