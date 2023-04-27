**NOTE:** If you are looking for Glodroid 1.0, please navigate to the
[master branch](https://github.com/GloDroid/glodroid_manifest/tree/master)

# GloDroid 2.0

## Ports

At this moment we ported the following devices to GloDroid 2.0:

[PinePhone](https://github.com/GloDroidCommunity/pine64-pinephone)

[PinePhone-Pro](https://github.com/GloDroidCommunity/pine64-pinephonepro)

[Raspberry PI 4](https://github.com/GloDroidCommunity/raspberry-pi)

We are currently working on porting the remaining devices / adding new ones.

## Introduction

GloDroid is an Android port that aims to bring both user- and developer-friendly
experience in using AOSP with a set of single-board computers (SBC), phones and
other devices.

Version 2.0 brings a mono-repository approach, which gives the following benefits
compared to the classic manifest-based approach:

1. No need to maintain forks. All necessary delta is stored in the form of patches.
   Benefits: Such patches are a lot easier to maintain. No need to merge/rebase
   fork repositories. Patches are much easier to review by external auditors to
   ensure high project trustworthiness.

2. Atomic changes.
   Benefits: Classic approach may require synchronization of multiple changes in
   different repositories. Gerrit has a "Topic: " field for this purpose, but
   GitHub/GitLab doesn't support such flow. The mono-repository approach makes it possible.
   CI is much easier to integrate.

3. Decouple devices or devices group from each other.
   As time has shown, maintaining all devices under the same manifest is impractical.
   It significantly increases the release cycle since all devices must be validated before
   publishing. Also, some devices may require custom patches on top of AOSP or vendor
   components, while others don't.
   It also allows different people to maintain different devices independently,
   benefiting from using a common code, without waiting for each other.
