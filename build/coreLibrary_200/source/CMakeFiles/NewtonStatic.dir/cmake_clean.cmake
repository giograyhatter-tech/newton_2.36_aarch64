file(REMOVE_RECURSE
  "../../lib/libNewton.a"
  "../../lib/libNewton.pdb"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/NewtonStatic.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
