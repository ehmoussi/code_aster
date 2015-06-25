#ifndef ASSEMBLYMATRIX_H_
#define ASSEMBLYMATRIX_H_

/**
 * @file AssemblyMatrix.h
 * @brief Fichier entete de la classe AssemblyMatrix
 * @author Nicolas Sellenet
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <stdexcept>
#include <list>

#include "astercxx.h"
#include "aster_fort.h"

#include "DataStructure/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxCollection.h"
#include "LinearAlgebra/ElementaryMatrix.h"
#include "Loads/ListOfLoads.h"
#include "RunManager/CommandSyntaxCython.h"

/**
 * @brief But de cette ligne : casser la reference circulaire
 * @todo Attention includes circulaires entre AssemblyMatrix, DOFNumbering et LinearSolver
 */
#include "Discretization/ForwardDOFNumbering.h"
#include "LinearAlgebra/ForwardLinearSolver.h"

/**
 * @class AssemblyMatrixInstance
 * @brief Classe template definissant une sd_matr_asse.
 *        Cette classe est volontairement succinte car on n'en connait pas encore l'usage
 * @author Nicolas Sellenet
 */
template< class ValueType >
class AssemblyMatrixInstance: public DataStructure
{
    private:
        /** @typedef std::list de KinematicsLoad */
        typedef std::list< KinematicsLoadPtr > ListKinematicsLoad;
        /** @typedef Iterateur sur une std::list de KinematicsLoad */
        typedef ListKinematicsLoad::iterator ListKinematicsLoadIter;

        /** @brief Objet Jeveux '.REFA' */
        JeveuxVectorChar24            _description;
        /** @brief Collection '.VALM' */
        JeveuxCollection< ValueType > _matrixValues;
        /** @brief Objet '.CONL' */
        JeveuxVectorDouble            _scaleFactorLagrangian;
        /** @brief ElementaryMatrix sur lesquelles sera construit la matrice */
        ElementaryMatrixPtr           _elemMatrix;
        /** @brief Objet nume_ddl */
        ForwardDOFNumberingPtr        _dofNum;
        /** @brief Objet sd_solver */
        ForwardLinearSolverPtr        _linSolv;
        /** @brief La matrice est elle vide ? */
        bool                          _isEmpty;
        /** @brief Liste de charges cinematiques */
        ListOfLoadsPtr                _listOfLoads;

    public:
        /**
         * @brief Constructeur
         */
        AssemblyMatrixInstance( const JeveuxMemory memType = Permanent );

        /**
         * @brief Destructeur
         */
        ~AssemblyMatrixInstance()
        {
#ifdef __DEBUG_GC__
            std::cout << "AssemblyMatrixInstance.destr: " << this->getName() << std::endl;
#endif
        };

        /**
         * @brief Methode permettant d'ajouter un chargement
         * @param currentLoad objet MechanicalLoad
         */
        void addKinematicsLoad( const KinematicsLoadPtr& currentLoad )
        {
            _listOfLoads->addKinematicsLoad( currentLoad );
        };

        /**
         * @brief Assemblage de la matrice
         */
        bool build() throw ( std::runtime_error );

        /**
         * @brief Factorisation de la matrice
         * @return true
        */
        bool factorization() throw ( std::runtime_error );

        /**
         * @brief Methode permettant de savoir si la matrice est vide
         * @return true si vide
         */
        bool isEmpty()
        {
            return _isEmpty;
        };

        /**
         * @brief Methode permettant de definir la numerotation
         * @param currentNum objet ForwardDOFNumbering
         */
        void setDOFNumbering( const ForwardDOFNumberingPtr& currentNum )
        {
            _dofNum = currentNum;
        };

        /**
         * @brief Methode permettant de definir les matrices elementaires
         * @param currentElemMatrix objet ElementaryMatrix
         */
        void setElementaryMatrix( const ElementaryMatrixPtr& currentElemMatrix )
        {
            _elemMatrix = currentElemMatrix;
        };

        /**
         * @brief Methode permettant de definir le solveur linéaire
         * @param currentLS objet ForwardLinearSolver
         */
        void setLinearSolver( const ForwardLinearSolverPtr& currentLS )
        {
            _linSolv = currentLS;
        };

        /**
         * @brief Methode permettant de definir la liste de chargement
         * @param lLoads objet de type ListOfLoadsPtr
         */
        void setListOfLoads( const ListOfLoadsPtr& lLoads )
        {
            _listOfLoads = lLoads;
        };
};

/** @typedef Definition d'une matrice assemblee de double */
typedef AssemblyMatrixInstance< double > AssemblyMatrixDoubleInstance;
/** @typedef Definition d'une matrice assemblee de complexe */
typedef AssemblyMatrixInstance< DoubleComplex > AssemblyMatrixComplexInstance;

typedef boost::shared_ptr< AssemblyMatrixDoubleInstance > AssemblyMatrixDoublePtr;
typedef boost::shared_ptr< AssemblyMatrixComplexInstance > AssemblyMatrixComplexPtr;

template< class ValueType >
AssemblyMatrixInstance< ValueType >::AssemblyMatrixInstance( const JeveuxMemory memType ):
                DataStructure( "MATR_ASSE", memType ),
                _description( JeveuxVectorChar24( getName() + "           .REFA" ) ),
                _matrixValues( JeveuxCollection< ValueType >( getName() + "           .VALM" ) ),
                _scaleFactorLagrangian( JeveuxVectorDouble( getName() + "           .CONL" ) ),
                _isEmpty( true ),
                _listOfLoads( ListOfLoadsPtr( new ListOfLoadsInstance( memType ) ) )
{};

template< class ValueType >
bool AssemblyMatrixInstance< ValueType >::build() throw ( std::runtime_error )
{
    if ( ( ! _elemMatrix ) || _elemMatrix->isEmpty() )
        throw std::runtime_error( "Elementary matrix is empty" );
    long type = 1;
    if ( _elemMatrix->getType() == "MATR_ELEM_DEPL_R" )
    {
        type = 1;
        setType( getType() + "_DEPL_R" );
    }
    else
        throw std::runtime_error( "Not yet implemented" );

    if ( _dofNum.isEmpty() )
        throw std::runtime_error( "Numerotation is empty" );

    std::string solverName( " " );
    if ( ! _linSolv.isEmpty() )
        solverName = _linSolv.getName();

    std::string blanc( " " );
    std::string cumul( "ZERO" );
    long nbMatrElem = 1;
    CALL_ASMATR( &nbMatrElem, _elemMatrix->getName().c_str(), blanc.c_str(), _dofNum.getName().c_str(),
                 solverName.c_str(), _listOfLoads->getName().c_str(), cumul.c_str(), "G", &type,
                 getName().c_str() );
    _isEmpty = false;

    return true;
};

template< class ValueType >
bool AssemblyMatrixInstance< ValueType >::factorization() throw ( std::runtime_error )
{
    if ( _isEmpty )
        throw std::runtime_error( "Assembly matrix is empty" );
    if ( ! _linSolv )
        throw std::runtime_error( "Linear solver is missing" );
    if ( _linSolv.isEmpty() )
        throw std::runtime_error( "Linear solver is empty" );

    _linSolv.operator->().matrixFactorization( AssemblyMatrixDoublePtr( this ) );
//     CommandSyntaxCython cmdSt( "FACTORISER" );
//     cmdSt.setResult( getName(), getType() );
// 
//     SyntaxMapContainer dict;
//     // !!! Rajouter un if MUMPS !!!
//     dict.container[ "MATR_ASSE" ] = getName();
//     dict.container[ "ELIM_LAGR" ] = "LAGR2";
//     dict.container[ "TYPE_RESOL" ] = "AUTO";
//     dict.container[ "PRETRAITEMENTS" ] = "AUTO";
//     dict.container[ "PCENT_PIVOT" ] = 20;
//     dict.container[ "GESTION_MEMOIRE" ] = "IN_CORE";
//     dict.container[ "REMPLISSAGE" ] = 1.0;
//     dict.container[ "NIVE_REMPLISSAGE" ] = 0;
//     dict.container[ "STOP_SINGULIER" ] = "OUI";
//     dict.container[ "PRE_COND" ] = "LDLT_INC";
//     dict.container[ "NPREC" ] = 8;
//     cmdSt.define( dict );
// 
//     try
//     {
//         INTEGER op = 14;
//         CALL_EXECOP( &op );
//     }
//     catch( ... )
//     {
//         throw;
//     }
//     _isEmpty = false;

    return true;
};

#endif /* ASSEMBLYMATRIX_H_ */
