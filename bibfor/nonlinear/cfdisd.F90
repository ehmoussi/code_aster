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

function cfdisd(resoco, questz)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
    integer :: cfdisd
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=19) :: resoco
    character(len=*) :: questz
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (TOUTES METHODES - UTILITAIRE)
!
! LECTURE INFORMATIONS SUR L'ETAT DU CONTACT ACTUEL
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
!
!
!
!
    character(len=24) :: questi
    character(len=24) :: coco
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
    call jeveuo(coco, 'L', jcoco)
!
    if (questi .eq. 'NDIM') then
        cfdisd = zi(jcoco+1-1)
    else if (questi.eq.'NEQ') then
        cfdisd = zi(jcoco+2-1)
    else if (questi.eq.'NBLIAC') then
        cfdisd = zi(jcoco+3-1)
    else if (questi.eq.'LLF') then
        cfdisd = zi(jcoco+4-1)
    else if (questi.eq.'LLF1') then
        cfdisd = zi(jcoco+5-1)
    else if (questi.eq.'LLF2') then
        cfdisd = zi(jcoco+6-1)
    else if (questi.eq.'NESMAX') then
        cfdisd = zi(jcoco+7-1)
    else if (questi.eq.'NBLIAI') then
        cfdisd = zi(jcoco+8-1)
    else
        ASSERT(.false.)
    endif
!
    call jedema()
end function
