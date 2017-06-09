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

subroutine crsolv(method, renum, kacmum, blreps, solve, bas)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jevtbl.h"
#include "asterfort/sdsolv.h"
#include "asterfort/wkvect.h"
    real(kind=8) :: blreps
    character(len=*) :: method, renum, solve, bas, kacmum
!
!     CREATION D'UNE STRUCTURE SOLVEUR
!
!-----------------------------------------------------------------------
    integer :: islvi, islvk, islvr, nprec
    real(kind=8) :: resire
!-----------------------------------------------------------------------
!
    integer :: zslvk, zslvr, zslvi
    real(kind=8) :: epsmat
    character(len=1) :: base
    character(len=8) :: preco
    character(len=19) :: solveu
!
! ----------------------------------------------------------------------
!
! --- INITIALISATIONS
!
    call jemarq()
!
    solveu = solve
    base = bas
!
    preco = 'SANS'
!
    resire = 1.d-6
    nprec = 8
    epsmat=-1.d0
!
! --- CREATION DES DIFFERENTS ATTRIBUTS DE LA S.D. SOLVEUR
!
    zslvk = sdsolv('ZSLVK')
    zslvr = sdsolv('ZSLVR')
    zslvi = sdsolv('ZSLVI')
    call wkvect(solveu//'.SLVK', base//' V K24', zslvk, islvk)
    call wkvect(solveu//'.SLVR', base//' V R', zslvr, islvr)
    call wkvect(solveu//'.SLVI', base//' V I', zslvi, islvi)
!
! --- REMPLISSAGE DE LA S.D. SOLVEUR
!
    zk24(islvk-1+1) = method
    if ((method.eq.'MULT_FRONT') .or. (method.eq.'LDLT')) then
        zk24(islvk-1+2) = 'XXXX'
    else
        zk24(islvk-1+2) = preco
    endif
    if (method .eq. 'MUMPS') then
        zk24(islvk-1+3) = 'AUTO'
        zk24(islvk-1+5) = kacmum
        zk24(islvk-1+6) = 'LAGR2'
    else
        zk24(islvk-1+3) = 'XXXX'
        zk24(islvk-1+5) = 'XXXX'
        zk24(islvk-1+6) = 'XXXX'
    endif
    zk24(islvk-1+4) = renum
    zk24(islvk-1+7) = 'XXXX'
    zk24(islvk-1+8) = 'XXXX'
    zk24(islvk-1+9) = 'XXXX'
    zk24(islvk-1+10) = 'XXXX'
    zk24(islvk-1+11) = 'XXXX'
    zk24(islvk-1+12) = 'XXXX'
    zk24(islvk-1+13) = 'NON'
!
    zr(islvr-1+1) = epsmat
    zr(islvr-1+2) = resire
    if (method .eq. 'MUMPS') then
        zr(islvr-1+3) = 0.d0
        zr(islvr-1+4) = blreps
    else
        zr(islvr-1+3) = jevtbl('TAILLE_BLOC')
        zr(islvr-1+4) = 0.d0
    endif
!
    zi(islvi-1+1) = nprec
    zi(islvi-1+2) =-9999
    zi(islvi-1+3) =-9999
    zi(islvi-1+4) =-9999
    zi(islvi-1+5) =-9999
    zi(islvi-1+6) =-9999
    zi(islvi-1+7) =-9999
    zi(islvi-1+8) = 0
!
    call jedema()
!
end subroutine
