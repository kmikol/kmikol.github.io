CV_INPUT := _data/cv.yml
CV_PDF := assets/rendercv/rendercv_output/kamil_mikolaj_cv.pdf

.PHONY: cv
cv:
	rendercv render $(CV_INPUT) \
		--settings assets/rendercv/settings.yaml \
		--design assets/rendercv/design.yaml \
		--locale-catalog assets/rendercv/locale.yaml
	test -f $(CV_PDF)
	@echo "Generated $(CV_PDF)"
