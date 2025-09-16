tinyVision Zephyr SDK
#####################

.. image:: https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/actions/workflows/getting_started_on_linux.yml/badge.svg
   :target: https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/actions/workflows/getting_started_on_linux.yml

The tinyVision Zephyr SDK is a `Zephyr <https://zephyrproject.org/>`_
library that contains extra drivers and configuration for working with
the `tinyCLUNX33`_ USB3/MIPI module and its devkit, as well as other
boards by tinyVision.ai.

.. _tinyCLUNX33: https://tinyclunx33.tinyvision.ai


Getting started
***************

See the introduction to the
`tinyVision Zephyr SDK <https://tinyclunx33.tinyvision.ai/appnote_zephyr_sdk.html>`_.

tinyVision.ai is glad to offer further help to get you started with this board
via the `Discord <https://discord.com/invite/3qbXujE>`_ chat server or
by `Email <sales@tinyvision.ai>`_.


Getting the SDK
***************

The tinyCLUNX33 SDK is a regular Zephyr module repository, and it can
be included into any project by adding it to your project
[`west.yml`](https://github.com/tinyvision-ai-inc/tinyclunx33_zephyr_example/blob/tinyclunx33_sdk/west.yml)
configuration file.

For instance, the `tinyclunx33_zephyr_example`_ repository is
configured to depend on this ``tinyvision_zephyr_sdk`` in its `west.yml`_ file.
This means that downloading the SDK will be automatic while downloading
the ``tinyclunx33_zephyr_example`` repository.


UVC Manager missing
*******************

In case you encounter an error related to a ``uvcmanager.c`` file missing,
then you may ask tinyVision.ai to access this file and place it in your
``~/zephyrproject/``. It is only required to access the high-bandwidth
cores of this system.
