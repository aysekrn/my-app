from setuptools import setup, find_packages

setup(
    name="my-app",
    version="1.0.4",
    description="My app Description",
    author="Kalebu",
    package_dir={"": "src"},
    packages=find_packages(where="src"),

    # 📦 include non-python files inside packages
    package_data={
        "my-app": [
            "i18n/*.json",
            "assets/icons/*.png",
            "qml/**/*.qml",
            "data/*.json"
        ]
    },

    include_package_data=True,

    install_requires=[
        "PyQt5>=5.15"
    ],

    data_files= [
        ("share/my-app", ["app.json", "icon.png"])
    ],

    entry_points={
        "console_scripts": [
            "my-app=my_app.main:main"
        ]
    },

    python_requires=">=3.8",

    long_description="This is app store for orbitmini mini"
)
