# Release Process

## Setup
Choose a new version for the release.  It is best to set this to an environment variable
as we will be referring to it often

```bash
export newVersion=1.0.0
```

## Set the release version
Set the version of the poms to the release artifact version

```bash
./mvnw versions:set -DnewVersion=${newVersion} -DgenerateBackupPoms=false
```

## Build and Test
Build and test the release to ensure everything is correct

```bash
./mvnw clean install -Prelease
```

Update the tests to point to release and test:

```bash
./mvnw -f tests/pom.xml clean install
```

## Verify the GPG Signature
Verify the correct signature was used to sign the artifacts

```bash
gpg --verify target/maven-parent-${newVersion}.pom.asc
```

## Deploy the Release to Stagging
Deploy the release as a stagged release to Sonatype

```bash
./mvnw clean deploy -Prelease
```

If everything goes well, we’ll see, among the console outputs, the staging repository id created for the project like this:

```bash
* Created staging repository with ID "io.github.efenglu-1001".
```

## Inspect the stagged artifacts
Inspect the artifacts on Sonatype ensure they are correct

Let’s log in to [https://oss.sonatype.org](https://oss.sonatype.org) to 
inspect the artifacts we’ve deployed to staging. After login, we’ll click on 
Staging Repositories on the left side menu under the Build Promotion sub-menu and using the 
search bar at the top right of the page, we’ll search for the staging repository ID 
created e.g. **io.github.efenglu-1001** in this case.

We should be able to see and inspect the artifacts that were uploaded by the nexus staging Maven plugin.

If everything looks right select the stagged repository and click the **close** button.

## Commit and Tag Release
Git and tag the release to Github

```bash
git add .
git commit -m "Release ${newVersion}"
git tag ${newVersion}
git push --tags
# Roll back all the changes so they don't get added to the main codebase
git reset HEAD~1
git checkout .
git clean -fd
```

## Deploy the Release
Everything is good to go.  Mark the release to be deployed to central.

```bash
./mvnw nexus-staging:release -Prelease -DstagingRepositoryId=iogithubefenglu-1000
```