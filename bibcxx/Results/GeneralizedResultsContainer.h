#ifndef GENERALIZEDRESULTSCONTAINER_H_
#define GENERALIZEDRESULTSCONTAINER_H_

/**
 * @file GeneralizedResultsContainer.h
 * @brief Fichier entete de la classe GeneralizedResultsContainer
 * @author Natacha Béreux
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "Modal/StaticMacroElement.h"
#include "Results/DynamicResultsIndexing.h"
#include "Discretization/DOFNumbering.h"

/**
 * @class GeneralizedResultsContainerInstance
 * @brief Cette classe correspond a la sd_dyna_gene de Code_Aster.
 * Un objet sd_dyna_gene est un concept produit par un opérateur
 * dynamique sur base généralisée.
 * @author Natacha Béreux
 */
template < class ValueType > class GeneralizedResultsContainerInstance : public DataStructure {
  private:
    /** @brief DynamicResultsIndexing */
    DynamicResultsIndexingPtr _index;
    /** @brief Vecteur Jeveux '.DESC' */
    JeveuxVectorLong _desc;
    /** @brief Vecteur Jeveux '.DISC' */
    /* Valeur des instants/fréquences sauvegardées */
    JeveuxVectorDouble _abscissasOfSamples;
    /** @brief Vecteur Jeveux '.ORDR' */
    JeveuxVectorLong _indicesOfSamples;
    /** @brief Vecteur Jeveux '.DEPL' */
    JeveuxVector< ValueType > _displacement;
    /** @brief Vecteur Jeveux '.VITE' */
    JeveuxVector< ValueType > _velocity;
    /** @brief Vecteur Jeveux '.ACCE' */
    JeveuxVector< ValueType > _acceleration;
    /** @brief si résulte d'un proj_mesu_modal */
    ProjMesuPtr _projM;

  public:
    /**
     * @brief Constructeur
     */
    GeneralizedResultsContainerInstance( const std::string &name, const std::string &resuTyp )
        : DataStructure( name, 19, resuTyp ),
          _index( new DynamicResultsIndexingInstance( getName(), resuTyp ) ),
          _desc( JeveuxVectorLong( getName() + ".DESC" ) ),
          _abscissasOfSamples( JeveuxVectorDouble( getName() + ".DISC" ) ),
          _indicesOfSamples( JeveuxVectorLong( getName() + ".ORDR" ) ),
          _displacement( JeveuxVector< ValueType >( getName() + ".DEPL" ) ),
          _velocity( JeveuxVector< ValueType >( getName() + ".VITE" ) ),
          _acceleration( JeveuxVector< ValueType >( getName() + ".ACCE" ) ),
          _projM( new ProjMesuInstance( getName() + ".PROJM" ) ){};
    GeneralizedResultsContainerInstance( const std::string &resuTyp )
        : GeneralizedResultsContainerInstance( ResultNaming::getNewResultName(), resuTyp ){};
};

/** @typedef Définition d'un résultat généralisé à valeurs réelles */
template class GeneralizedResultsContainerInstance< double >;
typedef GeneralizedResultsContainerInstance< double > GeneralizedResultsContainerDoubleInstance;
typedef boost::shared_ptr< GeneralizedResultsContainerDoubleInstance >
    GeneralizedResultsContainerDoublePtr;

/** @typedef Définition d'un résultat généralisé à valeurs complexes */
template class GeneralizedResultsContainerInstance< DoubleComplex >;
typedef GeneralizedResultsContainerInstance< DoubleComplex >
    GeneralizedResultsContainerComplexInstance;
typedef boost::shared_ptr< GeneralizedResultsContainerComplexInstance >
    GeneralizedResultsContainerComplexPtr;

class NonLinearDescriptor {
  private:
    /** @brief Vecteur Jeveux '.NL.TYPE' */
    JeveuxVectorLong _type;
    /** @brief Vecteur Jeveux '.NL.VINT' */
    JeveuxVectorDouble _internalVar;
    /** @brief Vecteur Jeveux '.NL.VIND' */
    JeveuxVectorLong _vIndi;
    /** @brief Vecteur Jeveux '.NL.INTI */
    JeveuxVectorChar24 _vInti;

  public:
    /**
     * @brief Constructeur
    */
    NonLinearDescriptor( const std::string &name )
        : _type( JeveuxVectorLong( name + ".NL.TYPE" ) ),
          _internalVar( JeveuxVectorDouble( name + ".NL.VINT" ) ),
          _vIndi( JeveuxVectorLong( name + ".NL.VIND" ) ),
          _vInti( JeveuxVectorChar24( name + ".NL.INTI" ) ){};
};

class TransientGeneralizedResultsContainerInstance
    : public GeneralizedResultsContainerDoubleInstance {
  private:
    /** @brief Vecteur Jeveux '.PTEM' */
    /*  valeur du pas de temps aux instants de calcul sauvegardés*/
    JeveuxVectorDouble _timeSteps;
    /** @brief Vecteur Jeveux '.FACC' */
    /* Nom et type des fonctions d’excitation de type accélération */
    JeveuxVectorChar8 _acceExcitFunction;
    /** @brief Vecteur Jeveux '.FVIT' */
    /* Nom et type des fonctions d’excitation de type vitesse */
    JeveuxVectorChar8 _veloExcitFunction;
    /** @brief Vecteur Jeveux '.FDEP' */
    /* Nom et type des fonctions d’excitation de type vitesse */
    JeveuxVectorChar8 _displExcitFunction;
    /** @brief Vecteur Jeveux '.IPSD' */
    JeveuxVectorLong _ipsd;
    /** @brief Description des nonlinéarités (si mot-clé COMPORTEMENT) */
    NonLinearDescriptor _nonLinDesc;
    /** @brief Support DOFNumbering */
    DOFNumberingPtr _dofNum;

  public:
    /**
     * @typedef TransientGeneralizedResultsContainerPtr
     * @brief Pointeur intelligent vers un TransientGeneralizedResultsContainerInstance
     */
    typedef boost::shared_ptr< TransientGeneralizedResultsContainerInstance >
        TransientGeneralizedResultsContainerPtr;

    /**
     * @brief Constructeur
     */
    TransientGeneralizedResultsContainerInstance()
        : TransientGeneralizedResultsContainerInstance( ResultNaming::getNewResultName() ){};

    /**
     * @brief Constructeur
     */
    TransientGeneralizedResultsContainerInstance( const std::string &name )
        : GeneralizedResultsContainerDoubleInstance( name, "TRAN_GENE" ), _nonLinDesc( name ),
          _timeSteps( JeveuxVectorDouble( getName() + ".PTEM" ) ),
          _acceExcitFunction( JeveuxVectorChar8( getName() + ".FACC" ) ),
          _veloExcitFunction( JeveuxVectorChar8( getName() + ".FVIT" ) ),
          _displExcitFunction( JeveuxVectorChar8( getName() + ".FDEP" ) ),
          _ipsd( JeveuxVectorLong( getName() + ".IPSD" ) ), _dofNum( nullptr ){};

    DOFNumberingPtr getDOFNumbering() const { return _dofNum; };

    bool setDOFNumbering( const DOFNumberingPtr &dofNum ) { _dofNum = dofNum; };
};
typedef boost::shared_ptr< TransientGeneralizedResultsContainerInstance >
    TransientGeneralizedResultsContainerPtr;

/**
 * @class HarmoGeneralizedResultsContainerInstance
 * @brief Cette classe correspond aux concepts  harm_gene,
 * résultats de calcul dynamique harmonique sur base généralisée
 * @author Natacha Béreux
 */
class HarmoGeneralizedResultsContainerInstance : public GeneralizedResultsContainerComplexInstance {
  private:
  public:
    /**
     * @typedef HarmoGeneralizedResultsContainerPtr
     * @brief Pointeur intelligent vers un HarmoGeneralizedResultsContainerInstance
     */
    typedef boost::shared_ptr< HarmoGeneralizedResultsContainerInstance >
        HarmoGeneralizedResultsContainerPtr;

    /**
     * @brief Constructeur
     */
    HarmoGeneralizedResultsContainerInstance()
        : HarmoGeneralizedResultsContainerInstance( ResultNaming::getNewResultName() ){};

    /**
     * @brief Constructeur
     */
    HarmoGeneralizedResultsContainerInstance( const std::string &name )
        : GeneralizedResultsContainerComplexInstance( name, "HARM_GENE" ){};
};

typedef boost::shared_ptr< HarmoGeneralizedResultsContainerInstance >
    HarmoGeneralizedResultsContainerPtr;

#endif /* GENERALIZEDRESULTSCONTAINER_H_ */
