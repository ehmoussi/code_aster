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

subroutine exmano(noma, numnoe, numano, nbmano)
    implicit none
! EXTRACTION DES NUMEROS DES MAILLES DE TYPE SEG2 DONT L'UNE DES
! EXTREMITES EST UN NOEUD DE NUMERO DONNE
!-----------------------------------------------------------------------
!  IN : NOMA   : NOM DU CONCEPT DE TYPE MAILLAGE
!  IN : NUMNOE : NUMERO DU NOEUD CONSIDERE
!  OUT: NUMANO : LISTE DES NUMEROS DES MAILLES SEG2 DONT L'UNE DES
!                EXTREMITES EST LE NOEUD DE NUMERO NUMNOE (CE VECTEUR
!                EST SURDIMENSIONNE LORS DE SA CREATION PAR L'APPELANT)
!  OUT: NBMANO : NOMBRE DE MAILLES SEG2 DONT L'UNE DES EXTREMITES EST
!                LE NOEUD DE NUMERO NUMNOE
!-----------------------------------------------------------------------
!
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
    character(len=8) :: noma
    integer :: numnoe, numano(*), nbmano
!
    character(len=24) :: mlgnma, mlgtma, mlgcnx
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: jdno, jdtm, nbmail, no1, no2, ntseg, numail
    integer :: nutyma
!-----------------------------------------------------------------------
    call jemarq()
!
    call jenonu(jexnom('&CATA.TM.NOMTM', 'SEG2'), ntseg)
!
    mlgnma = noma//'.NOMMAI'
    call jelira(mlgnma, 'NOMMAX', nbmail)
    mlgtma = noma//'.TYPMAIL'
    call jeveuo(mlgtma, 'L', jdtm)
    mlgcnx = noma//'.CONNEX'
!
    nbmano = 0
    do 10 numail = 1, nbmail
        nutyma = zi(jdtm+numail-1)
        if (nutyma .eq. ntseg) then
            call jeveuo(jexnum(mlgcnx, numail), 'L', jdno)
            no1 = zi(jdno)
            no2 = zi(jdno+1)
            if (no1 .eq. numnoe .or. no2 .eq. numnoe) then
                nbmano = nbmano + 1
                numano(nbmano) = numail
            endif
        endif
10  end do
!
    call jedema()
!
end subroutine
