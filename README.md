# Maven Pom Configuration

[![Build Status](https://travis-ci.com/efenglu/maven.svg?branch=master)](https://travis-ci.com/efenglu/maven)

Best practices for a full featured maven pom including:
 * Maven Tiles
 * Checkstyle Config
 * Examples as tests

## Usage

Configuring a project:
```xml
<plugin>
    <groupId>io.repaint.maven</groupId>
    <artifactId>tiles-maven-plugin</artifactId>
    <version>2.12</version>
    <extensions>true</extensions>
    <configuration>
        <tiles>
            <tile>io.github.efenglu.maven.tiles:project-java:[1.0, 2)</tile>
        </tiles>
    </configuration>
</plugin>
```