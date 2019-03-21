# Writing a Full Featured Maven Pom

## Parts of a POM
Maven is a build tool with a structured build pipeline. It alloys extensive 
customization for your own needs. You can get a build going with very little 
in your pom. But a good build, that follows everything you should probably 
do within a CI/CD pipeline takes a bit more.

## Basic Information
Every project should describe itself. 

For maven this means defining at a bare minimum:
```xml
<project>
    <groupId>com.efenglu.examplePom</groupId>
    <artifactId>example.pom</artifactId>
    <version>1.0.X-SNAPSHOT</version>
</project>
```

But you should really also include:
 * Name
   - Human readable name for the project
 * Description
   - More human stuff about your project
 * URL
   - Main url to go to for information about the project, typically same as scm url but not always
 * Issue Management
   - Where users can go if they have problems
 * Licenses
   - WHat License governs the use of your code
 * SCM
   - Where is the code stored
   
Example:
```xml
<project>
    <groupId>com.efenglu.examplePom</groupId>
    <artifactId>example.pom</artifactId>
    <version>1.0.X-SNAPSHOT</version>
    
    <name>Full Featured Maven Pom Example</name>
    <description>Project to a complete set of plugins for development</description>
    <url>https://github.com/efenglu/fullFeaturedPom</url>
    
    <issueManagement>
        <url>https://github.com/efenglu/fullFeaturedPom/issues</url>
        <system>GitHub Issues</system>
    </issueManagement>
    
    <licenses>
        <license>
            <name>MIT License</name>
            <url>http://www.opensource.org/licenses/mit-license.php</url>
            <distribution>repo</distribution>
        </license>
    </licenses>
    
    <scm>
        <url>https://github.com/efenglu/fullFeaturedPom</url>
        <connection>scm:git:git://github.com/efenglu/fullFeaturedPom.git</connection>
        <developerConnection>scm:git:git@github.com:efenglu/fullFeaturedPom.git</developerConnection>
    </scm>
</project>
```

## Encoding
Maven needs to how it should treat your text.  This is done through project enoding.  

Almost always this is UTF-8:
```xml
<project>
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    </properties>
</project>
```

## Compiler
Now that we have the basics we need to get to coding, and by coding we of course mean compiling.

### Javac
By default the javac compiler is basically all setup.  But, there are a few housekeeping things we need to do

 * Choose which version of java the source and compiled classes we will target
 * Include debugging flags?
 * Any other javac flags or custom arguments
 
For most of our projects we follow a pretty simple pattern:
```xml
<project>
    <properties>
        <java.version>1.8</java.version>
        <java.showDeprecation>false</showDeprecation>
        <java.showWarnings>false</showWarnings>
        <java.optimize>true</java.optimize>
        <java.debug>true</java.debug>
        <maven-compiler-plugin.version>3.7.0</maven-compiler-plugin.version>
    </properties>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>${maven-compiler-plugin.version}</version>
                <configuration>
                    <optimize>${java.optimize}</optimize>
                    <debug>${java.debug}</debug>
                    <source>${java.version}</source>
                    <target>${java.version}</target>
                    <showDeprecation>${java.showDeprecation}</showDeprecation>
                    <showWarnings>${java.showWarnings}</showWarnings>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```
Further Reading
 * [Apache Maven Compiler Plugin](https://maven.apache.org/plugins/maven-compiler-plugin/)

### Groovy
For most of our projects we use the Spock testing framework.  This means we need to compile groovy code
in order to run the tests.

We have tried all sorts of groovy compilers.  Each has their advantages and disadvantages.  For now we 
have chosen GMavenPlus.

```xml
<project>
    <build>
        <plugins>
            <plugin>
                <groupId>org.codehaus.gmavenplus</groupId>
                <artifactId>gmavenplus-plugin</artifactId>
                <version>1.6.2</version>
                <executions>
                    <execution>
                        <goals>
                            <goal>compileTests</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

Further Reading
 * [GMavenPlus](https://github.com/groovy/GMavenPlus)

### Lombok
Lombok is a great way to reduce code complexity in Java.  We use it extensively when creating our POJO's

For the most part, simply including lombok as a **provided** dependency *should* be enough.

```xml
    <dependencies>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.1</version>
            <scope>provided</scope>
        </dependency>
    </dependencies>
``` 

Further Reading:
 * [Lombok](https://projectlombok.org)
 * [Lombok Maven](https://projectlombok.org/setup/maven)

## Code Generation
This is more of an optional section.  T

here are many tools that *assist* you by generating code
for you at build time.  There are several different examples of this.  

We will focus on:
 * Protobuf

### Protobuf
Protocol buffers is a fast growing binary interchange format originally written by Google. Protocol buffers
are defined in **.proto** files.  These are then *compiled* into various languages.  Here is how 
we go about *compiling* our proto files.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project>

    <properties>
        <protobuf.plugin.version>0.6.1</protobuf.plugin.version>
        <grpc.version>1.18.0</grpc.version>
    </properties>

    <build>
        <resources>
            <resource>
                <directory>src/main/proto</directory>
            </resource>
            <resource>
                <directory>src/main/resources</directory>
            </resource>
        </resources>

        <plugins>
            <plugin>
                <groupId>kr.motd.maven</groupId>
                <artifactId>os-maven-plugin</artifactId>
                <version>1.6.1</version>
                <extensions>true</extensions>
                <executions>
                    <execution>
                        <phase>initialize</phase>
                        <goals>
                            <goal>detect</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
            <plugin>
                <groupId>org.xolstice.maven.plugins</groupId>
                <artifactId>protobuf-maven-plugin</artifactId>
                <version>${protobuf.plugin.version}</version>
                <configuration>
                    <useArgumentFile>true</useArgumentFile>
                    <protocArtifact>com.google.protobuf:protoc:3.6.1:exe:${os.detected.classifier}</protocArtifact>
                </configuration>
                <executions>
                    <execution>
                        <id>protobuf.java</id>
                        <goals>
                            <goal>compile</goal>
                        </goals>
                        <phase>generate-sources</phase>
                    </execution>
                    <execution>
                        <id>protobuf.grpc-java</id>
                        <goals>
                            <goal>compile-custom</goal>
                        </goals>
                        <phase>generate-sources</phase>
                        <configuration>
                            <pluginId>grpc-java</pluginId>
                            <pluginArtifact>io.grpc:protoc-gen-grpc-java:${grpc.version}:exe:${os.detected.classifier}</pluginArtifact>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

The os-maven-plugin will detect our build environment platform.  This is then used in determining which 
platform specific protoc executable to download.  The protobuf-maven-plugin then uses that executable
to compile the actual *.proto* files into java code.

Further Reading:
 * [Protocol Buffers](https://developers.google.com/protocol-buffers/)
 * [Maven Protobuf Plugin](https://www.xolstice.org/protobuf-maven-plugin/)

## Unit Tests

Good units tests are critical to the future, and present, of any successful project.

Thankfully, setting up units tests is fairly easy:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project>

    <properties>
        <maven-surefire-plugin.version>2.20</maven-surefire-plugin.version>
    </properties>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>${maven-surefire-plugin.version}</version>
                <configuration>
                    <includes>
                        <include>**/*Spec.*</include>
                        <include>**/*Specs.*</include>
                        <include>**/*Test.*</include>
                        <include>**/*Tests.*</include>
                    </includes>
                </configuration>
            </plugin>
        </plugins>
    </build>

    <reporting>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-report-plugin</artifactId>
                <version>${maven-surefire-plugin.version}</version>
            </plugin>
        </plugins>
    </reporting>

</project>
```

You may have noticed the includes elements.  We enforce a naming standard for our tests.  They must end in
either "Test", "Tests" for JUnit tests or "Spec", "Specs" or Spock Specifications.

Further Reading:
 * [Maven Surefire Plugin](https://maven.apache.org/surefire/maven-surefire-plugin/index.html)

## Code Coverage
Ensuring code is actually tested is critical.  A good metric to determine if code has been tested is Code Coverage.
It is not a perfect metric and you should probably never require 100% coverage.  But it is a great way to ensure
at least some level of compliance with testing.  But then again we all follow TDD to a tee and this shouldn't be
a problem, right?

There are two big players when it comes to code coverage, Jacoco and Cobertura.  We use Jacoco.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project>

    <properties>
        <jacoco.version>0.8.3</jacoco.version>
        <jacoco.bundle.coveredratio.minimum>0.70</jacoco.bundle.coveredratio.minimum>
    </properties>

    <build>
        <plugins>
            <plugin>
                <groupId>org.jacoco</groupId>
                <artifactId>jacoco-maven-plugin</artifactId>
                <version>${jacoco.version}</version>
                <executions>
                    <execution>
                        <id>jacoco-initialize</id>
                        <phase>initialize</phase>
                        <goals>
                            <goal>prepare-agent</goal>
                        </goals>
                    </execution>
                    <execution>
                        <id>jacoco-check</id>
                        <phase>test</phase>
                        <goals>
                            <goal>check</goal>
                        </goals>
                        <configuration>
                            <rules>
                                <rule implementation="org.jacoco.maven.RuleConfiguration">
                                    <element>BUNDLE</element>
                                    <excludes>
                                        <exclude>**/altova/**/*.*</exclude>
                                        <exclude>**/*Spec.*</exclude>
                                        <exclude>**/*Specs.*</exclude>
                                        <exclude>**/*Test.*</exclude>
                                        <exclude>**/*Tests.*</exclude>
                                    </excludes>
                                    <limits>
                                        <limit>
                                            <counter>INSTRUCTION</counter>
                                            <value>COVEREDRATIO</value>
                                            <minimum>${jacoco.bundle.coveredratio.minimum}</minimum>
                                        </limit>
                                    </limits>
                                </rule>
                            </rules>
                        </configuration>
                    </execution>
                    <execution>
                        <id>jacoco-site</id>
                        <phase>verify</phase>
                        <goals>
                            <goal>report</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

We enforce code coverage of 70%.

Further Reading:
 * [Jacoco Maven Plugin](https://www.eclemma.org/jacoco/trunk/doc/maven.html)

## Integration Tests
Some tests take longer than others.  Some tests are more complicated and require more setup and resources.
These are great example of integration tests.  Most integration tests are run later in the build process.
Sometime integration are not run at all on developer workstations.  

We follow a pattern of placing integration tests into a *src/it/java* path structure.  

This separates the integration tests from the regular tests.  However, since maven doesn't **really** 
recognize the concept of integration tests it is also necessary to name the tests differently since all the tests
get compiled into a single test class classpath.

For our project all integration tests must end in **IT**.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-failsafe-plugin</artifactId>
                <configuration>
                    <skip>${it.skip}</skip>
                    <includes>
                        <include>**/*IT.*</include>
                    </includes>
                </configuration>
                <executions>
                    <execution>
                        <id>integration-test</id>
                        <goals>
                            <goal>integration-test</goal>
                            <goal>verify</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>

    <reporting>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-report-plugin</artifactId>
                <reportSets>
                    <reportSet>
                        <id>integration-tests</id>
                        <reports>
                            <report>failsafe-report-only</report>
                        </reports>
                    </reportSet>
                </reportSets>
            </plugin>
        </plugins>
    </reporting>

</project>
```

## Static Code Analysis
Statis code analysis is another way to prevent bugs from happening.  You can scan your codebase for common programming
mistakes and catch them early.  You can also ensure a level of code quality and coding standards to ensure the code
is easy to read.

There are lots of different SCA tools:
 * [Checkstyle](https://maven.apache.org/plugins/maven-checkstyle-plugin/)
 * [PMD](https://maven.apache.org/plugins/maven-pmd-plugin/)
 * [CPD](https://maven.apache.org/plugins/maven-pmd-plugin/cpd-mojo.html)
 * [Spotbugs](https://spotbugs.github.io) (Successor to Findbugs)
 * [Codenarc](https://gleclaire.github.io/codenarc-maven-plugin/)
 * etc.
 
For now we will focus on Checkstyle as an example.

### Checkstyle
Checkstyle enforces code formatting and checks for some very basic bad programming practices.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project>
    <properties>
        <checkstyle.console>true</checkstyle.console>
        <checkstyle.failOnViolation>true</checkstyle.failOnViolation>
        <checkstyle.skip>false</checkstyle.skip>
        <maven-checkstyle-plugin.version>2.17</maven-checkstyle-plugin.version>
        <checkstyle.version>6.19</checkstyle.version>
        <checkstyle.config.version>1.0.X-SNAPSHOT</checkstyle.config.version>
    </properties>

    <build>
        <pluginManagement>
            <plugins>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-checkstyle-plugin</artifactId>
                    <version>${maven-checkstyle-plugin.version}</version>
                    <dependencies>
                        <dependency>
                            <groupId>com.efenglu.maven</groupId>
                            <artifactId>checkstyle-config</artifactId>
                            <version>${checkstyle.config.version}</version>
                        </dependency>
                        <dependency>
                            <groupId>com.puppycrawl.tools</groupId>
                            <artifactId>checkstyle</artifactId>
                            <version>${checkstyle.version}</version>
                        </dependency>
                    </dependencies>
                    <configuration>
                        <configLocation>checkstyle.xml</configLocation>
                        <encoding>${project.build.sourceEncoding}</encoding>
                    </configuration>
                </plugin>
            </plugins>
        </pluginManagement>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-checkstyle-plugin</artifactId>
                <executions>
                    <execution>
                        <id>verify-checkstyle</id>
                        <phase>verify</phase>
                        <goals>
                            <goal>check</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>

    <reporting>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-checkstyle-plugin</artifactId>
                <version>${maven-checkstyle-plugin.version}</version>
                <reportSets>
                    <reportSet>
                        <reports>
                            <report>checkstyle</report>
                        </reports>
                    </reportSet>
                </reportSets>
            </plugin>
        </plugins>
    </reporting>

</project>
```

#### Things of Note
We configure checkstyle in the plugin management section to ensure if the user invokes checkstyle from the command
line then they will get the correct configuration. 

It is also recommended that you define your own checkstyle configuration.  You should deploy this as its own artifact 
and consume it in the checkstyle plugin.  You can see where I defined my own version in the dependency I added to the
checkstyle plugin.  This jar is available to checkstyle on the classpath and you can load a resource from that jar
using *configLocation* element.

## Maven Enforcer
Just like there is SCA for code the Maven Enforcer is a kind of static code analysis of your maven poms.

We use the enforcer to ensure:
 * requireMavenVersion: 3.5.0
 * requireJavaVersion: 1.8.0
 * requireNoRepositories: No other repository elements in our poms
 * requireReleaseDeps: We don't reference a snapshot artifact in a release artifact
 * requireUpperBoundDeps: We don't have version conflicts in our dependencies

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project>
    <properties>
        <maven.version>3.5.0</maven.version>
        <enforcer.requireReleaseDeps.onlyWhenRelease>true</enforcer.requireReleaseDeps.onlyWhenRelease>
        <java.version>1.8</java.version>
        <enforcer.searchTransitive>true</enforcer.searchTransitive>
    </properties>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-enforcer-plugin</artifactId>
                <executions>
                    <execution>
                        <id>default-cli</id>
                        <goals>
                            <goal>enforce</goal>
                        </goals>

                        <configuration>
                            <rules>
                                <requireMavenVersion>
                                    <version>${maven.version}</version>
                                </requireMavenVersion>
                                <requireJavaVersion>
                                    <version>${java.version}</version>
                                </requireJavaVersion>

                                <requireNoRepositories>
                                    <!-- Define allowed repositories, use repo id -->
                                    <allowedRepositories>
                                        <id>bintray</id>
                                        <id>spring-milestones</id>
                                        <id>confluent</id>
                                        <id>projectlombok.org</id>
                                    </allowedRepositories>
                                    <allowedPluginRepositories>
                                        <id>bintray</id>
                                        <id>spring-milestones</id>
                                        <id>confluent</id>
                                        <id>projectlombok.org</id>
                                    </allowedPluginRepositories>
                                </requireNoRepositories>

                                <requireReleaseDeps>
                                    <message>No Snapshots Allowed in releases!</message>
                                    <onlyWhenRelease>${enforcer.requireReleaseDeps.onlyWhenRelease}</onlyWhenRelease>
                                </requireReleaseDeps>

                                <requireUpperBoundDeps>
                                    <!-- 'uniqueVersions' (default:false) can be set to true if you want to compare the timestamped SNAPSHOTs  -->
                                    <!-- <uniqueVersions>true</uniqueVersions> -->
                                    <!-- If you wish to ignore certain cases: -->
                                    <excludes>
                                        <exclude>com.google.guava:guava</exclude>
                                    </excludes>
                                </requireUpperBoundDeps>
                            </rules>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>

</project>
```

Further reading:
 * [Maven Enforcer Plugin](https://maven.apache.org/enforcer/maven-enforcer-plugin/)
 
## Maven Dependency Analyzer
TK

## Packaging
TK
MANIFEST Entries

## Versioning
TK

## Source Jar
TK

## Jar Signing
TK

## Deployment
TK

## Fat Jar?
TK

## Docker
TK

## Sharing Configuration
Ok, so that's a lot.  Your pom is probably well over 1000 lines long now.  Not only that its very complicated and
hard to reproduce.  Sure it does **everything** we want it to but what good it that if we can't easily maintain 
the configuration across lots of projects.  

There are really two ways to go about doing this.  Neither is perfect but together they can get pretty close.

### Parent Poms
Maven support the concept of inheritance of poms.  You can do this easily by specifying a *parent* element in your pom.

```xml
<parent>
    <artifactId>tiles-parent</artifactId>
    <groupId>com.efenglu.maven.tiles</groupId>
    <version>1.0.X-SNAPSHOT</version>
</parent>
```

The child will now receive all the configuration from the parent.  You can override settings in the child and 
add additional to your hearts content.

Parents are also a great place to setup *dependencyManagement* and *pluginManagement* sections.  This ensures all
your child modules will use the same version of a dependency and the same version of a plugin in their build.

Some things to be aware of.  Its difficult to exclude something.  Meaning if the parent defines a plugin its
not very easy for the child to turn that plugin off.  Therefore, be careful about adding ALL your configuration into 
a single monster parent.

That's where the second approach becomes useful

## Tiles
Maven doesn't natively support a concept of composition of configuration.  But a third party tool, known as 
[Maven Tiles](https://github.com/repaint-io/maven-tiles) brings that capability.

Maven tiles allow you to compose in project configuration:
```xml
<plugin>
    <groupId>io.repaint.maven</groupId>
    <artifactId>tiles-maven-plugin</artifactId>
    <extensions>true</extensions>
    <configuration>
        <tiles>
            <tile>io.repaint.tiles:github-release-tile:[1.1, 2)</tile>
            <tile>com.efenglu.maven.tiles:checkstyle:[1.0, 2)</tile>
        </tiles>
    </configuration>
</plugin>
```

*Note:* You can not use tiles in a parent as a way for all the children to get the tile.  It doesn't work that
way.  Tiles are mean to be used directly where they are needed.

## Parent Pom's And Tiles
I recommend you put *some* common configuration in your parent poms.  

**DO** include in your parent pom:
  * Basic Project configuration (scm, url, issuement management etc)
  * pluginManagement
  * dependencyManagement
  * encoding

**DO NOT** include in your parent pom:
 * dependencies
 * tiles
 
**DO** Use tiles on all your leaf projects to configure the build as needed in a repeatable way.

## Flattening
Now that you have your set of parents and all your plugins you have one last anoyance.  If someone goes
to use your library as it stands they will also have to download all your parent poms.  On top of that, all your
poms that you deployed to your artifact repository will still contain all your build configuration.

In order to clean up those poms and eliminate the need to download the parents we can *flatten* a pom.

Flattening a pom brings all the dependencies into a single pom.  It also removes a lot of unnecessary information from
the pom that is deployed.  Things like, plugins, properties, reporting etc.

```xml
```

# Conclusion
We covered LOTS of stuff here and only scratched the surface of how you can customize the plugins we mentioned here.
Hopefully, this provides a building block for your own maven endeavors.

Don't forget to checkout all the code mentioned over along with complete example and tiles for each plugin at my
githug repo, [efenglu/maven](https://github.com/efenglu/maven)