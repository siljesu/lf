include_guard()
message("device_MK22F51212_CMSIS component is included.")


target_include_directories(${MCUX_SDK_PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/.
)

include(CMSIS_Include_core_cm_MK22F51212)

