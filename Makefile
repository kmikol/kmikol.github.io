CV_INPUT := _data/cv.yml
CV_TYP := assets/rendercv/rendercv_output/Kamil_Mikolaj_CV.typ
CV_PDF := assets/rendercv/rendercv_output/kamil_mikolaj_cv.pdf
PYTHON ?= python3.11

.PHONY: cv
cv:
	rendercv render $(CV_INPUT) \
		--design assets/rendercv/design.yaml \
		--output-folder-name assets/rendercv/rendercv_output \
		--dont-generate-pdf \
		--dont-generate-markdown \
		--dont-generate-html \
		--dont-generate-png
	$(PYTHON) assets/rendercv/postprocess_typst.py $(CV_TYP) --cv $(CV_INPUT) --pdf $(CV_PDF)
	test -f $(CV_PDF)
	@echo "Generated $(CV_PDF)"
