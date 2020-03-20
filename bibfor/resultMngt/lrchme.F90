! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------
!
subroutine lrchme(fieldNameAst, fieldNameMed ,&
                  meshMed     , meshAst      ,&
                  fieldSupport, fieldQuantity, entityType,&
                  cmpNb       , cmpAstName   , cmpMedName,&
                  prolz, iinst, numpt, numord, inst,&
                  storeCrit, storeEpsi, fileUnit, option, param,&
                  nbpgma, nbpgmm, nbspmm, codret)
!
implicit none
!
#include "asterfort/getvid.h"
#include "asterfort/lrceme.h"
#include "asterfort/lrcnme.h"
#include "asterfort/utmess.h"
!
character(len=19) :: fieldNameAst
character(len=*) :: cmpAstName, cmpMedName
character(len=8) :: meshAst
character(len=8) :: fieldQuantity
character(len=4) :: fieldSupport
character(len=3) :: prolz
character(len=8) :: storeCrit, param
character(len=24) :: option
character(len=64) :: fieldNameMed, meshMed
integer :: fileUnit, entityType
integer :: codret
integer :: cmpNb
integer :: iinst, numpt, numord
integer :: nbpgma(*), nbpgmm(*), nbspmm(*)
real(kind=8) :: inst
real(kind=8) :: storeEpsi
!
! --------------------------------------------------------------------------------------------------
!
! MED reader
!
! Read field
!
! --------------------------------------------------------------------------------------------------
!
!        CHANOM  : NOM ASTER DU CHAMP A LIRE
!        NOCHMD : NOM MED DU CHAMP DANS LE FICHIER
!        NOMAMD : NOM MED DU MAILLAGE LIE AU CHAMP A LIRE
!                  SI ' ' : ON SUPPOSE QUE C'EST LE PREMIER MAILLAGE
!                           DU FICHIER
!        NOMAAS : NOM ASTER DU MAILLAGE
!        TYPECH : TYPE DU CHAMP
!        TYPENT : TYPE D'ENTITE DU CHAMP
!                (MED_NOEUD=3,MED_MAILLE=0,MED_NOEUD_MAILLE=4)
!        NOMGD  : NOM DE LA GRANDEUR ASSOCIEE AU CHAMP
!        NBCMPV : NOMBRE DE COMPOSANTES VOULUES
!                 SI NUL, ON LIT LES COMPOSANTES A NOM IDENTIQUE
!        NCMPVA : LISTE DES COMPOSANTES VOULUES POUR ASTER
!        NCMPVM : LISTE DES COMPOSANTES VOULUES DANS MED
!        PROLZ  : VALEUR DE PROL_ZERO ('OUI' OU 'NAN')
!        IINST  : 1 SI LA DEMANDE EST FAITE SUR UN INSTANT, 0 SINON
!        NUMPT  : NUMERO DE PAS DE TEMPS EVENTUEL
!        NUMORD : NUMERO D'ORDRE EVENTUEL DU CHAMP
!        INST   : INSTANT EVENTUEL
!        CRIT   : CRITERE SUR LA RECHERCHE DU BON INSTANT
!        PREC   : PRECISION SUR LA RECHERCHE DU BON INSTANT
!        NROFIC : NUMERO NROFIC LOGIQUE DU FICHIER MED
!        OPTION / PARAM : POUR CREER LE CHAMP COMME S'IL ETAIT LE
!                 PARAMETRE EN SORTIE DE CETTE OPTION (CHAMPS ELGA)
!     SORTIES:
!        CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: nommod
    integer :: iaux
!
! --------------------------------------------------------------------------------------------------
!
    if (fieldSupport(1:2) .eq. 'NO') then
        call lrcnme(fieldNameAst, fieldNameMed, meshMed, meshAst, fieldQuantity,&
                    entityType, cmpNb, cmpAstName, cmpMedName, iinst,&
                    numpt, numord, inst, storeCrit, storeEpsi,&
                    fileUnit, codret)
    else if (fieldSupport(1:2).eq.'EL'.or.fieldSupport(1:2).eq.'CA') then
        call getvid(' ', 'MODELE', scal=nommod, nbret=iaux)
        if (iaux .eq. 0 .and. fieldSupport(1:4) .ne. 'CART') then
            call utmess('F', 'MED_71')
        endif
        if (iaux .eq. 0) nommod = ' '
        call lrceme(fieldNameAst, fieldNameMed, fieldSupport(1:4), meshMed, meshAst,&
                    nommod, fieldQuantity, entityType, cmpNb, cmpAstName,&
                    cmpMedName, prolz, iinst, numpt, numord,&
                    inst, storeCrit, storeEpsi, fileUnit, option,&
                    param, nbpgma, nbpgmm, nbspmm, codret)
    else
        codret = 1
        call utmess('A', 'MED_92', sk=fieldSupport(1:4))
    endif
!
!====
! 2. BILAN
!====
!
    if (codret .ne. 0) then
        call utmess('A', 'MED_55', sk=fieldNameAst)
    endif
!
end subroutine
