#ifndef FIELDONNODES_H_
#define FIELDONNODES_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <string>
#include <assert.h>

#include "MemoryManager/JeveuxVector.h"
#include "DataStructure/DataStructure.h"
#include "RunManager/CommandSyntax.h"

/**
* class template FieldOnNodesInstance
*   Cette classe permet de definir un champ aux noeuds Aster
* @author Nicolas Sellenet
*/
template< class ValueType >
class FieldOnNodesInstance: public DataStructure
{
    private:
        // Vecteur Jeveux '.DESC'
        JeveuxVectorLong        _descriptor;
        // Vecteur Jeveux '.REFE'
        JeveuxVectorChar24      _reference;
        // Vecteur Jeveux '.VALE'
        JeveuxVector<ValueType> _valuesList;

    public:
        /**
        * Constructeur
        * @param name Nom Jeveux du champ aux noeuds
        */
        FieldOnNodesInstance( string name ):
                        DataStructure( name, "CHAM_NO" ),
                        _descriptor( JeveuxVectorLong( getName() + ".DESC" ) ),
                        _reference( JeveuxVectorChar24( getName() + ".REFE" ) ),
                        _valuesList( JeveuxVector< ValueType >( getName() + ".VALE" ) )
        {
            assert(name.size() == 19);
        };

        ~FieldOnNodesInstance()
        {}

        /**
        * Surcharge de l'operateur []
        * @param i Indice dans le tableau Jeveux
        * @return la valeur du tableau Jeveux a la position i
        */
        const ValueType &operator[](int i) const
        {
            return _valuesList->operator[](i);
        };

        /**
        * Impression du champ au format MED
        * @param pathFichier path ne servant pour le moment a rien
        * @return true
        */
        bool printMEDFormat( string pathFichier );

        /**
        * Mise a jour des pointeurs Jeveux
        * @return renvoit true si la mise a jour s'est bien deroulee, false sinon
        */
        bool updateValuePointers()
        {
            bool retour = _descriptor->updateValuePointer();
            retour = ( retour && _reference->updateValuePointer() );
            retour = ( retour && _valuesList->updateValuePointer() );
            return retour;
        };
};

template< class ValueType >
bool FieldOnNodesInstance< ValueType >::printMEDFormat( string pathFichier )
{
    CommandSyntax syntaxeImprResu( "IMPR_RESU", false );

    SimpleKeyWordStr mCSChamNo = SimpleKeyWordStr( "FORMAT" );
    mCSChamNo.addValues( "MED" );
    syntaxeImprResu.addSimpleKeywordStr( mCSChamNo );

    FactorKeyword motCleResu = FactorKeyword( "RESU", false );
    FactorKeywordOccurence occurResu = FactorKeywordOccurence();

    SimpleKeyWordStr mCSChamGd( "CHAM_GD" );
    mCSChamGd.addValues( getName() );
    occurResu.addSimpleKeywordStr( mCSChamGd );

    SimpleKeyWordInt mCSUnite( "UNITE" );
    mCSUnite.addValues( 80 );
    occurResu.addSimpleKeywordInteger( mCSUnite );

    SimpleKeyWordStr mCSInfo( "INFO_MAILLAGE" );
    mCSInfo.addValues( "NON" );
    occurResu.addSimpleKeywordStr( mCSInfo );

    SimpleKeyWordStr mCSNomVari( "IMPR_NOM_VARI" );
    mCSNomVari.addValues( "NON" );
    occurResu.addSimpleKeywordStr( mCSNomVari );

    motCleResu.addOccurence( occurResu );
    syntaxeImprResu.addFactorKeyword( motCleResu );

    CALL_EXECOP( 39 );

    return true;
};

/**
* class template FieldOnNodes
*   Enveloppe d'un pointeur intelligent vers un FieldOnNodesInstance
* @author Nicolas Sellenet
*/
template<class ValueType>
class FieldOnNodes
{
    public:
        typedef boost::shared_ptr< FieldOnNodesInstance< ValueType > > FieldOnNodesTypePtr;

    private:
        FieldOnNodesTypePtr _fieldOnNodesPtr;

    public:
        FieldOnNodes()
        {};

        FieldOnNodes(string nom): _fieldOnNodesPtr( new FieldOnNodesInstance< ValueType > (nom) )
        {};

        ~FieldOnNodes()
        {};

        FieldOnNodes& operator=(const FieldOnNodes< ValueType >& tmp)
        {
            _fieldOnNodesPtr = tmp._fieldOnNodesPtr;
            return *this;
        };

        const FieldOnNodesTypePtr& operator->(void) const
        {
            return _fieldOnNodesPtr;
        };

        bool isEmpty() const
        {
            if ( _fieldOnNodesPtr.use_count() == 0 ) return true;
            return false;
        };
};

typedef FieldOnNodes<double> FieldOnNodesDouble;

#endif /* FIELDONNODES_H_ */
