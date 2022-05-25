^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package rosidl_typesupport_microxrcedds_c
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Forthcoming
-----------
* Fix bug on empty seq size (`#52 <https://github.com/micro-ROS/rosidl_typesupport_microxrcedds/issues/52>`_)
  (cherry picked from commit 81ddbcf9b06596a1ac835b7482fa296a2a7d1eb8)
  Co-authored-by: acuadros95 <acuadros1995@gmail.com>
* Fix regression aligment (`#46 <https://github.com/micro-ROS/rosidl_typesupport_microxrcedds/issues/46>`_) (`#56 <https://github.com/micro-ROS/rosidl_typesupport_microxrcedds/issues/56>`_)
  (cherry picked from commit e8e371ea9b441ad1159d81d3655f881f3efde1ef)
  Co-authored-by: Pablo Garrido <pablogs9@gmail.com>
* Fix ifdef _cplusplus (`#42 <https://github.com/micro-ROS/rosidl_typesupport_microxrcedds/issues/42>`_)
* Fix buffer advance & remove fprintf (backport `#36 <https://github.com/micro-ROS/rosidl_typesupport_microxrcedds/issues/36>`_) (`#38 <https://github.com/micro-ROS/rosidl_typesupport_microxrcedds/issues/38>`_)
  * Fix buffer advance & remove fprintf (`#36 <https://github.com/micro-ROS/rosidl_typesupport_microxrcedds/issues/36>`_)
  * Fix fprintf
  * Fix regression
  * Fix
  * Update CI
  (cherry picked from commit 3ded4e5401923d84c1a80dda7ca8e317f6ae20cd)
  # Conflicts:
  #	.github/workflows/ci.yml
  * Update
  Co-authored-by: Pablo Garrido <pablogs9@gmail.com>
* Use FindPython3 explicitly instead of FindPythonInterp implicitly (`#34 <https://github.com/micro-ROS/rosidl_typesupport_microxrcedds/issues/34>`_)
* Fix interpreter line position (`#31 <https://github.com/micro-ROS/rosidl_typesupport_microxrcedds/issues/31>`_)
* Enable ser/des with lack of memory (`#27 <https://github.com/micro-ROS/rosidl_typesupport_microxrcedds/issues/27>`_)
  * Initial corner cases tests
  This should fail
  * Fix
  * artifacts
  update
  User ros container
  * Update
* Add namespaced Arrays support (`#29 <https://github.com/micro-ROS/rosidl_typesupport_microxrcedds/issues/29>`_)
  * Add regresion test
  This should fail
  * Add event handlers
  * Fix
* Update ABI Stability section (`#28 <https://github.com/micro-ROS/rosidl_typesupport_microxrcedds/issues/28>`_)
* Update Quality level 2 (`#26 <https://github.com/micro-ROS/rosidl_typesupport_microxrcedds/issues/26>`_)
  * Initial QL
  * Update
  * Update CI
  * Update
  * Update
  * Update
  * Revert "Update"
  This reverts commit 991518a4b64d919d1aa686c8fafd4b6eb91512fe.
  * Update rosidl_typesupport_microxrcedds_c/PLATFORM_SUPPORT.md
  * Update rosidl_typesupport_microxrcedds_c/CONTRIBUTING.md
  * Update README.md
  * Apply suggestions from code review
  Co-authored-by: FranFin <58737168+FranFin@users.noreply.github.com>
  * Update .github/workflows/ci.yml
  Co-authored-by: FranFin <58737168+FranFin@users.noreply.github.com>
* Contributors: Antonio Cuadros, Pablo Garrido, Shane Loretz, mergify[bot]
