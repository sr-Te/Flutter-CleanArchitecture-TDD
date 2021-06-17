# Movies - Clean Architecture & TDD

[![Linkedin Badge](https://img.shields.io/badge/-Linkedin-0e76a8?style=flat&labelColor=0e76a8&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/jf96/) 
![visitors](https://visitor-badge.glitch.me/badge?page_id=sr-Te.movies-CleanArchitecture-TDD)
<a href="https://flutter.dev/">
  <img src="https://img.shields.io/badge/flutter-%3E%3D%202.0.0-green.svg"/>
</a>
<a href="https://flutter.dev/">
  <img src="https://img.shields.io/badge/tests-100%25-brightgreen"/>
</a>


## Introducción
Este proyecto consta de una aplicación móvil desarrollada en [Flutter](https://flutter.dev/), la cual muestra información acerca de películas 
haciendo consultas a la API de [themoviedb.org](https://www.themoviedb.org/).  

Se tiene como objetivo practicar, compartir y discutir los temas aprendidos en el blog de 
[Resocoder](https://resocoder.com/category/tutorials/flutter/tdd-clean-architecture/).

## Vista Previa
<p float="left">
  <img src="readme_sources/categories.gif" width="150" />
  <img src="readme_sources/movie_profile.gif" width="150" /> 
  <img src="readme_sources/search.gif" width="150" />
</p>

<!--#### APK-->
<!--[Obten tu APK]()-->

## Instalación Proyecto
* [Instalar Flutter](https://flutter.dev/docs/get-started/install)
* Crear una cuenta y obtener un [API KEY aquí](https://www.themoviedb.org/documentation/api)
* Copiar el ```API KEY``` obtenido en ``./lib/core/api/movies_api.dart``
* Flutter run


## Estructura del proyecto
estructura propuesta por [Resocoder](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)

<div>
<img src="./readme_sources/architecture.jpeg" alt="jpeg" width="340" height="410">
<div>

## Definiciones
#### Clean Architecture
Propuesta por [El tío Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).

La idea principal en la arquitectura limpia es separar el código en capas independientes, las cuales se vuelven más abstractas
cuando se avanza a las capas interiores.

Porque las capas interiores representan reglas que restringen a las capas exteriores, lo que vendría siendo **la regla
dependencia** (Las capas exteriores pueden depender de las interiores, pero no al revés).

<div>
<img src="./readme_sources/clean_architecture.jpeg" alt="jpeg" width="350" height="250">
<div>

La idea sería tener los requerimientos definidos, además de las entidades y casos de uso que contendrá nuestro proyecto. Teniendo estas 
reglas claras, se pueden escribir aquellos mecanismos que son necesarios para que el caso de uso sea bien ejecutado.

#### TDD
<a href="https://flutter.dev/">
  <img src="https://img.shields.io/badge/passed%20tests-66-blue"/>
</a>
<div>

**Test Driven Development:** es un proceso de desarrollo iterativo, donde el desarrollador escribe una prueba antes de escribir el código
suficiente para cumplirla y luego refactoriza si es necesario.

Las ventajas de este proceso es que el desarrollador se centra m√°s en los requisitos del software, preguntándose el por qué necesita la fracción de código 
que está punto de escribir, antes de continuar con la implementación. 

Mediante este proceso el desarrollador puede identificar requisitos mal definidos y mejorar
sus hábitos con el tiempo, lo que conducir√≠a a una mejora en su calidad de  código.

