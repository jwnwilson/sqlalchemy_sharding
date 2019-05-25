type_check:
	mypy main.py

run: type_check
	python main.py