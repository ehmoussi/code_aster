#ifndef BEHAVIOUR_H_
#define BEHAVIOUR_H_

/**
 * @file Behaviour.h
 * @brief Definition of the (nonlinear) behaviour
 * @author Natacha Béreux
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
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

/* person_in_charge: natacha.bereux at edf.fr */
#include "astercxx.h"

#include "LinearAlgebra/SolverControl.h"
#include "Materials/MaterialOnMesh.h"
#include "Mesh/MeshEntities.h"
#include "NonLinear/AllowedBehaviour.h"
#include "Modeling/Model.h"
#include "RunManager/CommandSyntaxCython.h"
#include "Utilities/GenericParameter.h"


class BehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        BehaviourInstance( ConstitutiveLawEnum law = Elas, DeformationEnum deformation = SmallDeformation ): 
		_constitutiveLaw( law ), 
                _deformationType( deformation ), 
                _relation("RELATION", std::string( ConstitutiveLawNames[ (int)_constitutiveLaw ] ), true ), 
                _relation_kit("RELATION_KIT", false), 
                _deformation("DEFORMATION",std::string( DeformationNames[ (int)_deformationType ] ), false ),
                _resiCplanMaxi("RESI_CPLAN_MAXI", false ), 
                _resiCplanRela("RESI_CPLAN_RELA", 1.E-06, false ), 
                _iterCplanMaxi("ITER_CPLAN_MAXI", 1, false ),
                _thetaParameter("PARM_THETA", 1.0, false ),
                _alphaParameter("PARM_ALPHA", 1.0, false ), 
                _resiInteMaxi("RESI_INTE_MAXI", false ),
                _resiInteRela("RESI_INTE_RELA", 1.E-06,  false ),
                _iterInteMaxi("ITER_INTE_MAXI", 20, false ), 
                _iterIntePas("ITER_INTE_PAS", 0, false ), 
                _integrationAlgorithm("ALGO_INTE", false ), 
                _tangentMatrix("TYP_MATR_TANG", false ),
                _threshold("SEUIL", false ),
                _amplitude("AMPLITUDE", false ),
                _tauxRetour("TAUX_RETOUR",false),
                _resiRadiRela("RESI_RADI_RELA",false) 
        {
        _listOfParameters.push_back( &_relation );
        _listOfParameters.push_back( &_relation_kit );
        _listOfParameters.push_back( &_deformation );
        _listOfParameters.push_back( &_resiCplanMaxi );
        _listOfParameters.push_back( &_resiCplanRela );
        _listOfParameters.push_back( &_iterCplanMaxi );
        _listOfParameters.push_back( &_thetaParameter );
        _listOfParameters.push_back( &_alphaParameter );
        _listOfParameters.push_back( &_resiInteMaxi);
        _listOfParameters.push_back( &_resiInteRela);
        _listOfParameters.push_back( &_iterInteMaxi);
        _listOfParameters.push_back( &_iterIntePas);
        _listOfParameters.push_back( &_integrationAlgorithm);
        _listOfParameters.push_back( &_tangentMatrix);
        _listOfParameters.push_back( &_threshold);
        _listOfParameters.push_back( &_amplitude);
        _listOfParameters.push_back( &_tauxRetour);
        _listOfParameters.push_back( &_resiRadiRela);
        };
  
        /**
         * @brief Récupération de la liste des paramètres du comportement
         * @return Liste constante des paramètres déclarés
         */
        const ListGenParam& getListOfParameters() const
        {
            return _listOfParameters;
        };
        /**
         * Choose a type of tangent matrix 
        */
        void setTangentMatrix(  TangentMatrixEnum matrixType )
        {
            _tangentMatrix = std::string( TangentMatrixNames[(int)matrixType] ); 
        };
     private:
        /** @brief ConstitutiveLaw*/
        ConstitutiveLawEnum _constitutiveLaw;
        /** @brief Deformation  */
        DeformationEnum _deformationType;
        /** @brief Contrôle de la convergence de la loi de comportement  */
        SolverControlPtr _control;
        //
        GenParam _relation;
        GenParam _relation_kit;
        GenParam _deformation;
        GenParam _resiCplanMaxi;
        GenParam _resiCplanRela;
        GenParam _iterCplanMaxi;
        GenParam _thetaParameter;
        GenParam _alphaParameter; 
        GenParam _resiInteMaxi;
        GenParam _resiInteRela;
        GenParam _iterInteMaxi;
        GenParam _iterIntePas;
        GenParam _integrationAlgorithm;
        GenParam _tangentMatrix;
        GenParam _threshold;
        GenParam _amplitude; 
        GenParam _tauxRetour;
        GenParam _resiRadiRela; 
 
        ListGenParam _listOfParameters;
};

/**
 * @typedef BehaviourPtr
 * @brief Enveloppe d'un pointeur intelligent vers un BehaviourInstance
 */
typedef boost::shared_ptr< BehaviourInstance > BehaviourPtr;


#endif /* BEHAVIOUR_H_ */
