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
#include "LinearAlgebra/DOFNumbering.h"
#include "LinearAlgebra/ElementaryMatrix.h"
#include "Loads/KinematicsLoad.h"
#include "RunManager/CommandSyntax.h"

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
        ElementaryMatrix              _elemMatrix;
        /** @brief Objet nume_ddl */
        DOFNumbering                  _dofNum;
        /** @brief La matrice est elle vide ? */
        bool                          _isEmpty;
        /** @brief Liste de charges cinematiques */
        ListKinematicsLoad            _listOfLoads;

    public:
        /**
         * @brief Constructeur
         */
        AssemblyMatrixInstance();

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
            _listOfLoads.push_back( currentLoad );
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
         * @brief Methode permettant de savoir si les matrices elementaires sont vides
         * @return true si les matrices elementaires sont vides
         */
        bool isEmpty()
        {
            return _isEmpty;
        };

        /**
         * @brief Methode permettant de definir la numerotation
         * @param currentElemMatrix objet ElementaryMatrix
         */
        void setDOFNumbering( const DOFNumbering& currentNum )
        {
            _dofNum = currentNum;
        };

        /**
         * @brief Methode permettant de definir les matrices elementaires
         * @param currentElemMatrix objet ElementaryMatrix
         */
        void setElementaryMatrix( const ElementaryMatrix& currentElemMatrix )
        {
            _elemMatrix = currentElemMatrix;
        };
};

template< class ValueType >
AssemblyMatrixInstance< ValueType >::AssemblyMatrixInstance():
                DataStructure( getNewResultObjectName(), "MATR_ASSE" ),
                _description( JeveuxVectorChar24( getName() + "           .REFA" ) ),
                _matrixValues( JeveuxCollection< ValueType >( getName() + "           .VALM" ) ),
                _scaleFactorLagrangian( JeveuxVectorDouble( getName() + "           .CONL" ) ),
                _elemMatrix( ElementaryMatrix( false ) ),
                _dofNum( DOFNumbering( false ) ),
                _isEmpty( true )
{};

template< class ValueType >
bool AssemblyMatrixInstance< ValueType >::factorization() throw ( std::runtime_error )
{
    if ( _isEmpty )
        throw std::runtime_error( "Assembly matrix is empty" );

    // Definition du bout de fichier de commande correspondant a ASSE_MATRICE
    CommandSyntax syntaxeFactoriser( "FACTORISER", true, getName(), getType() );

    // Definition du mot cle simple MATR_ASSE
    SimpleKeyWordStr mCSMatrAsse = SimpleKeyWordStr( "MATR_ASSE" );
    mCSMatrAsse.addValues( getName() );
    syntaxeFactoriser.addSimpleKeywordString( mCSMatrAsse );

    // !!! Rajouter un if MUMPS !!!
    // Definition du mot cle simple ELIM_LAGR
    SimpleKeyWordStr mCSElimLagr = SimpleKeyWordStr( "ELIM_LAGR" );
    mCSElimLagr.addValues( "LAGR2" );
    syntaxeFactoriser.addSimpleKeywordString( mCSElimLagr );

    SimpleKeyWordStr mCSTypeResol = SimpleKeyWordStr( "TYPE_RESOL" );
    mCSTypeResol.addValues( "AUTO" );
    syntaxeFactoriser.addSimpleKeywordString( mCSTypeResol );

    SimpleKeyWordStr mCSPretr = SimpleKeyWordStr( "PRETRAITEMENTS" );
    mCSPretr.addValues( "AUTO" );
    syntaxeFactoriser.addSimpleKeywordString( mCSPretr );

    SimpleKeyWordInt mCSPcentPivot = SimpleKeyWordInt( "PCENT_PIVOT" );
    mCSPcentPivot.addValues( 20 );
    syntaxeFactoriser.addSimpleKeywordInteger( mCSPcentPivot );

    SimpleKeyWordStr mCSMemoire = SimpleKeyWordStr( "GESTION_MEMOIRE" );
    mCSMemoire.addValues( "IN_CORE" );
    syntaxeFactoriser.addSimpleKeywordString( mCSMemoire );

    SimpleKeyWordDbl mCSRempl = SimpleKeyWordDbl( "REMPLISSAGE" );
    mCSRempl.addValues( 1.0 );
    syntaxeFactoriser.addSimpleKeywordDouble( mCSRempl );

    SimpleKeyWordInt mCSNiveRempl = SimpleKeyWordInt( "NIVE_REMPLISSAGE" );
    mCSNiveRempl.addValues( 0 );
    syntaxeFactoriser.addSimpleKeywordInteger( mCSNiveRempl );

    SimpleKeyWordStr mCSSing = SimpleKeyWordStr( "STOP_SINGULIER" );
    mCSSing.addValues( "OUI" );
    syntaxeFactoriser.addSimpleKeywordString( mCSSing );

    SimpleKeyWordStr mCSPrecond = SimpleKeyWordStr( "PRE_COND" );
    mCSPrecond.addValues( "LDLT_INC" );
    syntaxeFactoriser.addSimpleKeywordString( mCSPrecond );

    SimpleKeyWordInt mCSNprec = SimpleKeyWordInt( "NPREC" );
    mCSNprec.addValues( 8 );
    syntaxeFactoriser.addSimpleKeywordInteger( mCSNprec );

    INTEGER op = 14;
    CALL_EXECOP( &op );
    _isEmpty = false;

    return true;
};

template< class ValueType >
bool AssemblyMatrixInstance< ValueType >::build() throw ( std::runtime_error )
{
    if ( _elemMatrix.isEmpty() || _elemMatrix->isEmpty() )
        throw std::runtime_error( "Elementary matrix is empty" );
    if ( _elemMatrix->getType() == "MATR_ELEM_DEPL_R" )
        setType( getType() + "_DEPL_R" );
    else
        throw std::runtime_error( "Not yet implemented" );

    if ( _dofNum.isEmpty() || _dofNum->isEmpty() )
        throw std::runtime_error( "Numerotation is empty" );

    // Definition du bout de fichier de commande correspondant a ASSE_MATRICE
    CommandSyntax syntaxeAsseMatrice( "ASSE_MATRICE", true,
                                       getResultObjectName(), getType() );

    // Definition du mot cle simple MATR_ELEM
    SimpleKeyWordStr mCSMatrElem = SimpleKeyWordStr( "MATR_ELEM" );
    mCSMatrElem.addValues( _elemMatrix->getName() );
    syntaxeAsseMatrice.addSimpleKeywordString( mCSMatrElem );

    // Definition du mot cle simple NUME_DDL
    SimpleKeyWordStr mCSNumeDdl = SimpleKeyWordStr( "NUME_DDL" );
    mCSNumeDdl.addValues( _dofNum->getName() );
    syntaxeAsseMatrice.addSimpleKeywordString( mCSNumeDdl );

    if ( _listOfLoads.size() != 0 )
    {
        SimpleKeyWordStr mCSCharge( "CHAR_CINE" );
        for ( ListKinematicsLoadIter curIter = _listOfLoads.begin();
              curIter != _listOfLoads.end();
              ++curIter )
        {
            mCSCharge.addValues( (*curIter)->getName() );
        }
        syntaxeAsseMatrice.addSimpleKeywordString( mCSCharge );
    }

    INTEGER op = 12;
    CALL_EXECOP( &op );
    _isEmpty = false;

    return true;
};

/**
 * @class AssemblyMatrix
 * @brief Enveloppe d'un pointeur intelligent vers un AssemblyMatrix
 * @author Nicolas Sellenet
 */
template< class ValueType >
class AssemblyMatrix
{
    public:
        typedef boost::shared_ptr< AssemblyMatrixInstance< ValueType > > AssemblyMatrixPtr;

    private:
        AssemblyMatrixPtr _assemblyMatrixPtr;

    public:
        AssemblyMatrix(bool initialisation = true): _assemblyMatrixPtr()
        {
            if ( initialisation == true )
                _assemblyMatrixPtr = AssemblyMatrixPtr( new AssemblyMatrixInstance< ValueType >() );
        };

        ~AssemblyMatrix()
        {};

        AssemblyMatrix& operator=(const AssemblyMatrix& tmp)
        {
            _assemblyMatrixPtr = tmp._assemblyMatrixPtr;
            return *this;
        };

        const AssemblyMatrixPtr& operator->() const
        {
            return _assemblyMatrixPtr;
        };

        AssemblyMatrixInstance< ValueType >& operator*(void) const
        {
            return *_assemblyMatrixPtr;
        };

        bool isEmpty() const
        {
            if ( _assemblyMatrixPtr.use_count() == 0 ) return true;
            return false;
        };
};

/** @typedef Definition d'une matrice assemblee de double */
typedef AssemblyMatrix< double > AssemblyMatrixDouble;
/** @typedef Definition d'une matrice assemblee de complexe */
typedef AssemblyMatrix< DoubleComplex > AssemblyMatrixComplex;

#endif /* ASSEMBLYMATRIX_H_ */
