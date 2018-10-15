What is PiWitch?
================

The idea behind PiWitch is to have a simple package you can update directly
from git that will install and maintain a stand-alone dedicated SipWitchQt
server. This package uses ansible to configure and deploy SipWitchQt from a git
checkout.  While I call this PiWitch, it can be used to setup and maintain
any dedicated Debian or Ubuntu based SipWitchQt server though it may tune
things by default optimized for smaller device uses such as the raspberry Pi.

Part of the goal of this package is to introduce and deliver web services,
api's, and supporting features to use in conjunction with SipWitchQt.  This
would include web api's for integrating functionality, to provide current
client applications for end user deployment, etc.  Many additional services are
being developed in python and using flask.  These will be provided by piwitch
as they become ready for deployment.  The idea is to have a single package to
both setup and maintain complete stand-alone SipWitchQt solutions.

Other variants of this package may also be created over time, such as stigwitch
to provide a stand-alone solution for scifs using CentOS/RedHat.  Other kinds
of sip integrated applications (for example a sip speaker, or hvac control) for
deployment on stand-alone Pi devices may also be delivered similarly with
ansible in related packages in the future.


