#ifndef FIELDONNODES_H_
#define FIELDONNODES_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <string>
#include <assert.h>

#include "baseobject/JeveuxVector.h"

/**
* class template FieldOnNodesInstance
*   Cette classe permet de definir un champ aux noeuds Aster
* @author Nicolas Sellenet
*/
template<class ValueType>
class FieldOnNodesInstance
{
    private:
        // Nom Jeveux du champ
        string                  _name;
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
        FieldOnNodesInstance(string name): _name(name),
                                           _descriptor( JeveuxVectorLong(string(name+".DESC")) ),
                                           _reference( JeveuxVectorChar24(string(name+".REFE")) ),
                                           _valuesList( JeveuxVector<ValueType>(string(name+".VALE")) )
        {
            assert(name.size() == 19);
        };

        ~FieldOnNodesInstance()
        {}

        /**
        * Surcharge de l'operateur []
        * @param i Indice dans le tableau Jeveux
        * @return renvoit la valeur du tableau Jeveux a la position i
        */
        const ValueType &operator[](int i) const
        {
            return _valuesList->operator[](i);
        };

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
