! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine cfecrd(resoco, questz, ival)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: resoco
    character(len=*) :: questz
    integer :: ival
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (TOUTES METHODES - UTILITAIRE)
!
! ECRIRE INFORMATIONS SUR L'ETAT DU CONTACT ACTUEL
!
! ----------------------------------------------------------------------
!
!
! IN  RESOCO  : SD DE RESOLUTION DU CONTACT
! IN  QUESTI  : VALEUR A LIRE/ECRIRE
!   NDIM   : DIMENSION DE L'ESPACE
!   NBLIAC : NOMBRE DE LIAISON DE CONTACT ACTIVES
!   LLF    : NOMBRE DE LIAISON DE FROTTEMENT (DEUX DIRECTIONS)
!   LLF1   : NOMBRE DE LIAISON DE FROTTEMENT (1ERE DIRECTION )
!   LLF2   : NOMBRE DE LIAISON DE FROTTEMENT (2EME DIRECTION )
!   NBLIAI : NOMBRE DE LIAISONS (NOEUDS ESCLAVES APPARIES)
!   NEQ    : NOMBRE D'EQUATIONS DU SYSTEME
!   NESMAX : NOMBRE MAXI DE NOEUDS ESCLAVES (POUR DECALAGES)
! IN  IVAL    : VALEUR
!
!
!
!
    character(len=24) :: questi
    character(len=19) :: coco
    integer :: jcoco
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    questi = questz
!
! --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
!
    coco = resoco(1:14)//'.COCO'
    call jeveuo(coco, 'E', jcoco)
!
    if (questi .eq. 'NDIM') then
        zi(jcoco+1-1) = ival
    else if (questi.eq.'NEQ') then
        zi(jcoco+2-1) = ival
    else if (questi.eq.'NBLIAC') then
        zi(jcoco+3-1) = ival
    else if (questi.eq.'LLF') then
        zi(jcoco+4-1) = ival
    else if (questi.eq.'LLF1') then
        zi(jcoco+5-1) = ival
    else if (questi.eq.'LLF2') then
        zi(jcoco+6-1) = ival
    else if (questi.eq.'NESMAX') then
        zi(jcoco+7-1) = ival
    else if (questi.eq.'NBLIAI') then
        zi(jcoco+8-1) = ival
    else
        ASSERT(.false.)
    endif
!
    call jedema()
end subroutine
