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

subroutine mnlcdl(imat, numedd, xcdl, nd, lcine)
    implicit none
!
!
!       MODE NON LINEAIRE - GESTION DES CONDITIONS AUX LIMITES
!           POUR LES MATRICES DE MASSE ET DE RAIDEUR
!       -         -         ---
! ----------------------------------------------------------------------
!
! IN  IMAT   : I(2) : DESCRIPTEUR DES MATRICES :
!                       - IMAT(1) => MATRICE DE RAIDEUR
!                       - IMAT(2) => MATRICE DE MASSE
! IN  NUMEDD : K14  : NUME_DDL DES MATRICES DE MASSE ET RAIDEUR
! OUT XCDL   : K14  : VECTEUR D'INDICE DES DDLS ACTIFS (0) OU NON (1)
! OUT ND     : I    : NOMBRE DE DDLS ACTIFS
! OUT ND     : L    : .TRUE.  SI CDL = AFFE_CHAR_CINE 
!                     .FALSE. SINON  
! ----------------------------------------------------------------------
!
#include "asterf_types.h"
#include "jeveux.h"
!
! ----------------------------------------------------------------------
! --- DECLARATION DES ARGUMENTS DE LA ROUTINE
! ----------------------------------------------------------------------
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    aster_logical :: lcine
    integer :: imat(2), nd
    character(len=14) :: xcdl, numedd
! ----------------------------------------------------------------------
! --- DECLARATION DES VARIABLES LOCALES
! ----------------------------------------------------------------------
    character(len=19) :: matk
    integer :: lccid, iind, neq, k, j, tcmp, ndlag
    integer, pointer :: ccid(:) => null()
    integer, pointer :: deeq(:) => null()
!
    call jemarq()
! ----------------------------------------------------------------------
! --- VERIFICATION SI CONDITION CINEMATIQUE OU MECANIQUE
! ----------------------------------------------------------------------
! --- RECUPERATION NOM DE LA MATRICE
    matk=zk24(zi(imat(1)+1))(1:19)
! --- EXISTENCE DU CHAMP CCID (CDL CINE) DANS LA MATRICE
    call jeexin(matk//'.CCID', lccid)
! --- CREATION DU VECTEUR INDIQUANT SI ACTIF (0) OU NON(1)
    call jeveuo(xcdl, 'E', iind)
! --- TAILLE GLOBALE DE LA MATRICE DE RAIDEUR (OU DE MASSE)
    neq = zi(imat(1)+2)
!
! --- CAS MATR_ASSE_GENE
    if (lccid .gt. 0) then
! --- CAS AFFE_CHAR_CINE
        call jeveuo(matk//'.CCID', 'L', vi=ccid)
        do 10 k = 1, neq
            zi(iind-1+k)=ccid(k)
 10     continue
        nd=neq-ccid(neq+1)
        lcine = .true.
    else
! --- CAS AFFE_CHAR_MECA
        lcine = .false.
        call jeveuo(numedd//'.NUME.DEEQ', 'L', vi=deeq)
        do 20 k = 1, neq
            if (deeq(2*(k-1)+2) .gt. 0) then
                zi(iind-1+k)=0
            else if (deeq(2*(k-1)+2).lt.0) then
                zi(iind-1+k)=1
                j=1
                tcmp=-deeq(2*(k-1)+2)
 21             continue
                if (deeq(2*(j-1)+1) .ne. deeq(2*(k-1)+1) .or. deeq(2*(j-1)+2) .ne. tcmp) then
                    j=j+1
                    goto 21
                endif
                zi(iind-1+j)=1
            endif
 20     continue
        ndlag=0
        do 30 k = 1, neq
            if (zi(iind-1+k) .eq. 1) then
                ndlag=ndlag+1
            endif
 30     continue
        nd=neq-ndlag
    endif
!
    call jedema()
!
end subroutine
