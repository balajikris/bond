function (run)
    execute_process (
        COMMAND ${ARGV}
        RESULT_VARIABLE error)
    if (error)
        message (FATAL_ERROR)
    endif()
endfunction()

if (${TEST} STREQUAL schema)
    run (${GBC} schema --runtime-schema ${COMPAT_DATA}/../schemas/compat.bond)
    run (${BOND_COMPAT} ${TEST} -d compat.Compat.json expected.gbc.${TEST} deserialized.gbc.${TEST})
endif()

if (CSHARP_COMPAT)
    run (${CSHARP_COMPAT} ${TEST} ${COMPAT_DATA}/compat.${TEST}.dat compat.${TEST}.cs.dat ${TEST})
    run (${BOND_COMPAT} ${TEST} -d compat.${TEST}.cs.dat expected.cs.${TEST} deserialized.cs.${TEST})

    if (${TEST} STREQUAL schema)
        run (${CSHARP_COMPAT} ${TEST} compat.Compat.json compat.${TEST}.gbc.dat)
    endif()
endif()

if (JAVA_COMPAT)
    if (NOT JAVA_CORE)
        message(FATAL_ERROR "Cannot run Java compat without setting JAVA_CORE")
    endif()

    if (WIN32)
        set (PATHSEP "\\\;")
    else()
        set (PATHSEP ":")
    endif()

    run (java -classpath ${JAVA_CORE}${PATHSEP}${JAVA_COMPAT} com.microsoft.bond.compat.CompatDriver
        ${TEST} ${COMPAT_DATA}/compat.${TEST}.dat compat.${TEST}.java.dat ${TEST})
    run (${BOND_COMPAT} ${TEST} -d compat.${TEST}.java.dat expected.java.${TEST} deserialized.java.${TEST})

    if (${TEST} STREQUAL schema)
        run (java -classpath ${JAVA_CORE}${PATHSEP}${JAVA_COMPAT} com.microsoft.bond.compat.CompatDriver
            ${TEST} compat.Compat.json compat.${TEST}.gbc.dat)
    endif()
endif()