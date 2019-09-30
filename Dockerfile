# Mobile developer Google tools - Docker Image
# Start Package One - ubuntu base image
FROM ubuntu:18.04
LABEL MAINTAINER rosera

USER root

# Set up the environment variables
ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    FLUTTER_SDK_URL="https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.9.1+hotfix.2-stable.tar.xz" \
    STUDIO_URL="https://dl.google.com/dl/android/studio/ide-zips/3.4.0.18/android-studio-ide-183.5452501-linux.tar.gz" \
    ANDROID_BASE="/usr/local" \
    FLUTTER_BASE="/usr/local" \
    ANDROID_HOME="${ANDROID_BASE}/android-sdk" \
    ANDROID_VERSION=28 \
    ANDROID_BUILD_TOOLS_VERSION=28.0.3

# Install Build Essentials
RUN apt-get update \
    && apt-get install -y apt-utils \
    build-essential \
    curl \    
    file \
    git \
    openssh-client \
    unzip \
    xz-utils

# Install OpenJDK 8
RUN apt-get update \
    && apt-get install -y ant \
    curl \
    openjdk-8-jdk \
    tar \
    unzip \
    && update-alternatives --set "java" "/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java"

# Set the JAVA HOME
ENV JAVA_HOME "/usr/lib/jvm/java-8-openjdk-amd64"

# End Package One

# Start Package Two - Android SDK

# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
    && cd "$ANDROID_HOME" \
    && curl -o sdk.zip $SDK_URL \
    && unzip sdk.zip \
    && rm sdk.zip \
    && mkdir "$ANDROID_HOME/licenses" || true \
    && echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "$ANDROID_HOME/licenses/android-sdk-license"


# Install Android Build Tool and Libraries
RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"

# Accept the licenses
RUN  yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses

# End Package Two

# Add Optional Components - Flutter SDK, IDE (i.e. Android Studio, Intellij, VS Code) - note install Flutter before IDE

# Now install IDE - Android Studio / VS Code

# Install the Android Studio
#RUN mkdir "${ANDROID_BASE}/android-studio" \
#    && cd "${ANDROID_BASE}" \
#    && curl $STUDIO_URL -o android-studio.tar.gz \
#    && tar -xvf android-studio.tar.gz \
#    && rm android-studio.tar.gz

# Amend the working directory to local directory
#WORKDIR ${ANDROID_BASE}/android-studio/bin

#ENV PATH="$PATH:${ANDROID_BASE}/android-studio/bin"  
# Start Package Three - Flutter SDK (Optional)

# Download Flutter SDK
#RUN cd "${FLUTTER_BASE}" \
#    && curl -L "${FLUTTER_SDK_URL}" | tar -C "${FLUTTER_BASE}" -xJ 

# Add flutter to the path
#ENV PATH="$PATH:${FLUTTER_BASE}/flutter/bin"  

# Initialise the flutter environment
#RUN flutter doctor
#RUN flutter upgrade
#RUN flutter packages pub global activate webdev
#RUN flutter package upgrade

# End Package Three

# Start 

# Run the IDE
#ENTRYPOINT [ "./studio.sh" ]
