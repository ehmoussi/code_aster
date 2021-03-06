/**
 * @file ConvertersInterface.cxx
 * @brief Utilitaires pour convertir un vector en list et inversement
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   Code_Aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "PythonBindings/ConvertersInterface.h"
#include "DataStructures/DataStructure.h"
#include "Functions/Function.h"
#include "Loads/PhysicalQuantity.h"
#include "Materials/Material.h"
#include "Materials/MaterialField.h"
#include "Materials/MaterialProperty.h"
#include "Modeling/FiniteElementDescriptor.h"

void exportConverters() {

    exportVectorConverter< int >();
    exportVectorConverter< ASTERINTEGER >();
    exportVectorConverter< double >();
    exportVectorConverter< std::string >();
    exportVectorConverter< PhysicalQuantityComponent >();
    exportVectorConverter< MaterialPtr >();
    exportVectorConverter< FiniteElementDescriptorPtr >();
    exportVectorConverter< BaseFunctionPtr >();
    exportVectorConverter< FunctionPtr >();
    exportVectorConverter< PartOfMaterialFieldPtr >();
    exportVectorConverter< GenericMaterialPropertyPtr >();
    exportVectorConverter< DataStructurePtr >();

    exportJeveuxVectorConverter< short int >();
    exportJeveuxVectorConverter< ASTERINTEGER >();
    exportJeveuxVectorConverter< double >();

    exportJeveuxCollectionConverter< short int >();
    exportJeveuxCollectionConverter< ASTERINTEGER >();
    exportJeveuxCollectionConverter< double >();
};
