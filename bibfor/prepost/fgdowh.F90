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

subroutine fgdowh(nommat, nbcycl, sigmin, sigmax, lke,&
                  rke, lhaigh, rcorr, dom)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/limend.h"
#include "asterfort/rcvale.h"
    character(len=*) :: nommat
    real(kind=8) :: sigmin(*), sigmax(*)
    real(kind=8) :: rcorr(*), dom(*), rke(*)
    integer :: nbcycl
    aster_logical :: lhaigh, lke
!     CALCUL DU DOMMAGE ELEMENTAIRE PAR INTERPOLATION SUR
!     UNE COURBE DE WOHLER DONNEE POINT PAR POINT
!     ------------------------------------------------------------------
! IN  NOMMAT : K   : NOM DU MATERIAU
! IN  NBCYCL : I   : NOMBRE DE CYCLES
! IN  SIGMIN : R   : CONTRAINTES MINIMALES DES CYCLES
! IN  SIGMAX : R   : CONTRAINTES MAXIMALES DES CYCLES
! IN  LKE    : L   : INDIQUE LA PRISE EN COMPTE DE KE
! IN  RKE    : R   : VALEURS DE KE
! IN  LHAIGH : L   : PRISE EN COMPTE D'UNE CORRECTION DE HAIGH
! IN  RCORR  : R   : VALEURS DE LA CORRECTION DE HAIGH
! OUT DOM    : R   : VALEURS DES DOMMAGES ELEMENTAIRES
!     ------------------------------------------------------------------
!
    integer :: icodre(1)
    character(len=8) :: nompar, kbid
    character(len=16) :: nomres
    character(len=32) :: pheno
    real(kind=8) :: nrupt(1), delta
    aster_logical :: endur
!
!-----------------------------------------------------------------------
    integer :: i, nbpar
!-----------------------------------------------------------------------
    call jemarq()
    do 10 i = 1, nbcycl
        delta = (abs(sigmax(i)-sigmin(i)))/2.d0
        if (lke) delta = delta*rke(i)
        if (lhaigh) delta = delta/rcorr(i)
        nomres = 'WOHLER  '
        nbpar = 1
        pheno = 'FATIGUE   '
        nompar = 'SIGM    '
        call limend(nommat, delta, 'WOHLER', kbid, endur)
        if (endur) then
            dom(i) = 0.d0
        else
            call rcvale(nommat, pheno, nbpar, nompar, [delta],&
                        1, nomres, nrupt(1), icodre(1), 2)
            dom(i) = 1.d0/nrupt(1)
        endif
 10 end do
!
    call jedema()
end subroutine
