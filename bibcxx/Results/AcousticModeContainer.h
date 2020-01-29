#ifndef ACOUSTICMODECONTAINER_H_
#define ACOUSTICMODECONTAINER_H_

/**
 * @file AcousticModeContainer.h
 * @brief Fichier entete de la classe AcousticModeContainer
 * @author Natacha Béreux
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

#include "astercxx.h"

#include "Results/FullResultsContainer.h"
#include "LinearAlgebra/AssemblyMatrix.h"
#include "Supervis/ResultNaming.h"

/**
 * @class AcousticModeContainerClass
 * @brief Cette classe correspond a un mode_acou
 * @author Natacha Béreux
 */
class AcousticModeContainerClass : public FullResultsContainerClass {
  private:
    /** @brief Stiffness displacement matrix */
    AssemblyMatrixPressureDoublePtr _rigidityMatrix;

  public:
    /**
     * @brief Constructeur
     */
    AcousticModeContainerClass( const std::string &name )
        : FullResultsContainerClass( name, "MODE_ACOU" ), _rigidityMatrix( nullptr ){};

    AcousticModeContainerClass()
        : AcousticModeContainerClass( ResultNaming::getNewResultName() ){};
    /**
     * @brief Set the rigidity matrix
     * @param matr AssemblyMatrixPressureDoublePtr
     */
    bool setStiffnessMatrix( const AssemblyMatrixPressureDoublePtr &matr ) {
        _rigidityMatrix = matr;
        return true;
    };

    bool update() { return ResultsContainerClass::update(); };
};

/**
 * @typedef AcousticModeContainerPtr
 * @brief Pointeur intelligent vers un AcousticModeContainerClass
 */
typedef boost::shared_ptr< AcousticModeContainerClass > AcousticModeContainerPtr;

#endif /* ACOUSTICMODECONTAINER_H_ */
