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
                _relation("RELATION", true ), 
                _relation_kit("RELATION_KIT", false), 
                _deformation("DEFORMATION", false ),
                _resi_cplan_maxi("RESI_CPLAN_MAXI", false ), 
                _resi_cplan_rela("RESI_CPLAN_RELA", false ), 
                _iter_cplan_maxi("ITER_CPLAN_MAXI", false ),
                _parm_theta("PARM_THETA", false ),
                _parm_alpha("PARM_ALPHA", false ), 
                _resi_inte_maxi("RESI_INTE_MAXI", false ),
                _resi_inte_rela("RESI_INTE_RELA", false ),
                _iter_inte_maxi("ITER_INTE_MAXI", false ), 
                _iter_inte_pas("ITER_INTE_PAS", false ), 
                _algo_inte("ALGO_INTE", false ), 
                _type_matr_tang("TYP_MATR_TANG", false ),
                _seuil("SEUIL", false ),
                _amplitude("AMPLITUDE", false ),
                _taux_retour("TAUX_RETOUR",false),
                _resi_radi_rela("RESI_RADI_RELA",false) 
        {
        _relation = std::string( ConstitutiveLawNames[ (int)_constitutiveLaw ] );
	_deformation = std::string( DeformationNames[ (int)_deformationType ] );
        _resi_cplan_rela=1.E-06;
        _iter_cplan_maxi = 1;
        _parm_theta = 1.0;
        _parm_alpha= 1.0 ;
        _iter_inte_maxi = 20; 
        _resi_inte_rela = 1.E-06;
        _iter_inte_pas = 0; 

        _listOfParameters.push_back( &_relation );
        _listOfParameters.push_back( &_relation_kit );
        _listOfParameters.push_back( &_deformation );
        _listOfParameters.push_back( &_resi_cplan_maxi );
        _listOfParameters.push_back( &_resi_cplan_rela );
        _listOfParameters.push_back( &_iter_cplan_maxi );
        _listOfParameters.push_back( &_parm_theta );
        _listOfParameters.push_back( &_parm_alpha );
        _listOfParameters.push_back( &_resi_inte_maxi);
        _listOfParameters.push_back( &_resi_inte_rela);
        _listOfParameters.push_back( &_iter_inte_maxi);
        _listOfParameters.push_back( &_iter_inte_pas);
        _listOfParameters.push_back( &_algo_inte);
        _listOfParameters.push_back( &_type_matr_tang);
        _listOfParameters.push_back( &_seuil);
        _listOfParameters.push_back( &_amplitude);
        _listOfParameters.push_back( &_taux_retour);
        _listOfParameters.push_back( &_resi_radi_rela);
        };
  
        /**
         * @brief Récupération de la liste des paramètres du comportement
         * @return Liste constante des paramètres déclarés
         */
        const ListGenParam& getListOfParameters() const
        {
            return _listOfParameters;
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
        GenParam _resi_cplan_maxi;
        GenParam _resi_cplan_rela;
        GenParam _iter_cplan_maxi;
        GenParam _parm_theta;
        GenParam _parm_alpha; 
        GenParam _resi_inte_maxi;
        GenParam _resi_inte_rela;
        GenParam _iter_inte_maxi;
        GenParam _iter_inte_pas;
        GenParam _algo_inte;
        GenParam _type_matr_tang;
        GenParam _seuil;
        GenParam _amplitude; 
        GenParam _taux_retour;
        GenParam _resi_radi_rela; 
 
        ListGenParam _listOfParameters;
};

/**
 * @typedef BehaviourPtr
 * @brief Enveloppe d'un pointeur intelligent vers un BehaviourInstance
 */
typedef boost::shared_ptr< BehaviourInstance > BehaviourPtr;


#endif /* BEHAVIOUR_H_ */
