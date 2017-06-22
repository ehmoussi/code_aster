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

subroutine dffno(elrefe, ndim, nno, nnos, dff)
    implicit none
#include "asterfort/elraca.h"
#include "asterfort/elrfdf.h"
    character(len=*) :: elrefe
    integer :: ndim, nno, nnos
    real(kind=8) :: dff(*)
! BUT:   CALCUL DES DERIVEES DES FONCTIONS DE FORMES
!        AUX NOEUDS D'UN ELREFE
!
    integer :: nbnomx, nbfamx
    parameter    ( nbnomx=27, nbfamx=20)
    real(kind=8) :: x(nbnomx*3), vol, tab(3, nbnomx)
    integer :: dimd, nbfpg, nbpg(nbfamx), ino, ideri, ifonc, ibi1, ibi2
    character(len=8) :: fapg(nbfamx)
! ----------------------------------------------------------------------
!
    call elraca(elrefe, ndim, nno, nnos, nbfpg,&
                fapg, nbpg, x, vol)
!
    dimd = ndim*nno
!
    do 10 ino = 1, nno
!
        call elrfdf(elrefe, x(ndim*(ino-1)+1), dimd, tab, ibi1,&
                    ibi2)
!
        do 20 ideri = 1, ndim
            do 30 ifonc = 1, nno
                dff((ino-1)*nno*ndim+(ideri-1)*nno+ifonc)=tab(ideri,&
                ifonc)
30          continue
20      continue
!
10  end do
!
end subroutine
