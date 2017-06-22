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

subroutine cffpm1(resoco, nbliai, ndim, nesmax)
!
!
    implicit     none
#include "jeveux.h"
!
#include "asterc/r8prem.h"
#include "asterfort/jedema.h"
#include "asterfort/jelibe.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/r8inir.h"
#include "blas/daxpy.h"
    character(len=24) :: resoco
    integer :: nbliai, ndim, nesmax
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (RESOLUTION - PENALISATION)
!
! CALCUL DE LA MATRICE FRO1 = E_T*AaT
!
! ----------------------------------------------------------------------
!
!
! IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
! IN  NBLIAI : NOMBRE DE LIAISONS DE CONTACT POSSIBLES
! IN  NDIM   : DIMENSION DU PROBLEME
! IN  NESMAX : NOMBRE MAX DE NOEUDS ESCLAVES
!
!
!
!
    integer :: ndlmax
    parameter   (ndlmax = 30)
    integer :: jdecal, nbddl
    real(kind=8) :: xmu, jeuini
    integer :: iliai
    character(len=19) :: mu
    integer :: jmu
    character(len=24) :: appoin
    integer :: japptr
    character(len=24) :: apcofr
    integer :: japcof
    character(len=24) :: jeux
    integer :: jjeux
    character(len=19) :: fro1
    integer :: jfro11, jfro12
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
!
    appoin = resoco(1:14)//'.APPOIN'
    jeux = resoco(1:14)//'.JEUX'
    mu = resoco(1:14)//'.MU'
    apcofr = resoco(1:14)//'.APCOFR'
    fro1 = resoco(1:14)//'.FRO1'
    call jeveuo(jeux, 'L', jjeux)
    call jeveuo(mu, 'L', jmu)
    call jeveuo(appoin, 'L', japptr)
    call jeveuo(apcofr, 'L', japcof)
!
! --- CALCUL DE LA MATRICE E_T*AaT
!
    do 100 iliai = 1, nbliai
!
! ----- INITIALISATION DES COLONNES
!
        call jeveuo(jexnum(fro1, iliai), 'E', jfro11)
        call r8inir(ndlmax, 0.d0, zr(jfro11), 1)
        if (ndim .eq. 3) then
            call jeveuo(jexnum(fro1, iliai+nbliai), 'E', jfro12)
            call r8inir(ndlmax, 0.d0, zr(jfro12), 1)
        endif
!
! ----- LA LIAISON EST-ELLE ACTIVE ?
!
        jeuini = zr(jjeux+3*(iliai-1)+1-1)
!
! ----- CALCUL
!
        if (jeuini .lt. r8prem()) then
            jdecal = zi(japptr+iliai-1)
            nbddl = zi(japptr+iliai) - zi(japptr+iliai-1)
            xmu = zr(jmu+3*nbliai+iliai-1)
            call daxpy(nbddl, xmu, zr(japcof+jdecal), 1, zr(jfro11),&
                       1)
            if (ndim .eq. 3) then
                call daxpy(nbddl, xmu, zr(japcof+jdecal+ndlmax*nesmax), 1, zr(jfro12),&
                           1)
            endif
        endif
!
        call jelibe(jexnum(fro1, iliai))
        if (ndim .eq. 3) then
            call jelibe(jexnum(fro1, iliai+nbliai))
        endif
100  end do
!
    call jedema()
!
end subroutine
