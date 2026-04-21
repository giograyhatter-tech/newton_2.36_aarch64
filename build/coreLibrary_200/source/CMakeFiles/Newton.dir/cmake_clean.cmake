file(REMOVE_RECURSE
  "../../lib/libNewton.pdb"
  "../../lib/libNewton.so"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/Newton.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
