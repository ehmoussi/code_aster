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

subroutine cffpfo(resoco, nbliai, nbliac, ndim)
!
!
    implicit     none
#include "jeveux.h"
!
#include "asterfort/cfcglt.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: resoco
    integer :: nbliai, nbliac, ndim
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (RESOLUTION - PENALISATION)
!
! CALCUL DES COEFFICIENTS DE LAGRANGE MU POUR LE FROTTEMENT
!
! ----------------------------------------------------------------------
!
!
! IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
! IN  NBLIAI : NOMBRE DE LIAISONS DE CONTACT POSSIBLES
! IN  NBLIAC : NOMBRE DE LIAISONS ACTIVES
! IN  NDIM   : DIMENSION DU PROBLEME
!
!
!
!
    real(kind=8) :: coefpt, coefff, lambdc, lambdf
    real(kind=8) :: glis
    integer :: iliai, iliac
    character(len=19) :: mu, liac
    integer :: jmu, jliac
    character(len=24) :: tacfin
    integer :: jtacf
    integer :: ztacf
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
!
    tacfin = resoco(1:14)//'.TACFIN'
    liac = resoco(1:14)//'.LIAC'
    mu = resoco(1:14)//'.MU'
    call jeveuo(tacfin, 'L', jtacf)
    call jeveuo(liac, 'L', jliac)
    call jeveuo(mu, 'E', jmu)
    ztacf = cfmmvd('ZTACF')
!
! --- CALCUL DES COEFFICIENTS DE LAGRANGE MU
!
    do 100 iliac = 1, nbliac
!
! ----- REPERAGE DE LA LIAISON
!
        iliai = zi(jliac-1+iliac)
!
! ----- CALCUL DU JEU TANGENT
!
        call cfcglt(resoco, iliai, glis)
!
! ----- COEFFICIENTS
!
        coefff = zr(jtacf+ztacf*(iliai-1)+1-1)
        coefpt = zr(jtacf+ztacf*(iliai-1)+3-1)
!
! ----- LAMBDA DE CONTACT ET DE FROTTEMENT
!
        lambdc = zr(jmu+iliac-1)
        if (lambdc .gt. 0.d0) then
            lambdf = coefff*lambdc
        else
            lambdf = 0.d0
        endif
!
! ----- ACTIVATION GLISSEMENT/ADHERENCE
!
        if (zr(jmu+2*nbliai+iliai-1) .ne. 0.d0) then
            if (glis .le. (lambdf/coefpt)) then
                zr(jmu+3*nbliai+iliai-1) = sqrt(coefpt)
            else
                zr(jmu+3*nbliai+iliai-1) = sqrt(lambdf/glis)
            endif
        else
            zr(jmu+3*nbliai+iliai-1) = 0.d0
        endif
100  end do
!
    call jedema()
!
end subroutine
