#ifndef ACOUSTICMODERESULT_H_
#define ACOUSTICMODERESULT_H_

/**
 * @file AcousticModeResult.h
 * @brief Fichier entete de la classe AcousticModeResult
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

#include "Results/FullResult.h"
#include "LinearAlgebra/AssemblyMatrix.h"
#include "Supervis/ResultNaming.h"

/**
 * @class AcousticModeResultClass
 * @brief Cette classe correspond a un mode_acou
 * @author Natacha Béreux
 */
class AcousticModeResultClass : public FullResultClass {
  private:
    /** @brief Stiffness displacement matrix */
    AssemblyMatrixPressureRealPtr _rigidityMatrix;

  public:
    /**
     * @brief Constructeur
     */
    AcousticModeResultClass( const std::string &name )
        : FullResultClass( name, "MODE_ACOU" ), _rigidityMatrix( nullptr ){};

    AcousticModeResultClass()
        : AcousticModeResultClass( ResultNaming::getNewResultName() ){};
    /**
     * @brief Set the rigidity matrix
     * @param matr AssemblyMatrixPressureRealPtr
     */
    bool setStiffnessMatrix( const AssemblyMatrixPressureRealPtr &matr ) {
        _rigidityMatrix = matr;
        return true;
    };

    bool update() { return ResultClass::update(); };
};

/**
 * @typedef AcousticModeResultPtr
 * @brief Pointeur intelligent vers un AcousticModeResultClass
 */
typedef boost::shared_ptr< AcousticModeResultClass > AcousticModeResultPtr;

#endif /* ACOUSTICMODERESULT_H_ */
