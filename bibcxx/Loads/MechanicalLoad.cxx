
#include <stdexcept>
#include <typeinfo>
#include "astercxx.h"

#include "Loads/MechanicalLoad.h"
#include <typeinfo>


const std::string LoadTraits <NodalForce>::factorKeyword = "FORCE_NODALE"; 

const std::string LoadTraits <ForceOnFace>::factorKeyword = "FORCE_FACE";

const std::string LoadTraits <ForceOnEdge>::factorKeyword = "FORCE_ARETE"; 

const std::string LoadTraits <LineicForce>::factorKeyword = "FORCE_CONTOUR"; 
