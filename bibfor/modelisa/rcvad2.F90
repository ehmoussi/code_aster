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

subroutine rcvad2(fami, kpg, ksp, poum, jmat,&
                  phenom, nbres, nomres, valres, devres,&
                  icodre)
    implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/rcfode.h"
#include "asterfort/rcvarc.h"
#include "asterfort/utmess.h"
    integer :: kpg, ksp, imat, nbres, jmat
    character(len=*) :: fami, poum
    integer :: icodre(nbres)
    character(len=16) :: nomres(nbres)
    character(len=*) :: phenom
    real(kind=8) :: temp, valres(nbres), devres(nbres)
! ......................................................................
!     OBTENTION DE LA VALEUR DES COEFFICIENTS DU MATERIAU ET DE LEURS
!     DERIVEES PAR RAPPORT A LA TEMPERATURE
!
! IN   IMAT   : ADRESSE DU MATERIAU CODE
! IN   PHENOM : PHENOMENE
! IN   TEMP   : TEMPERATURE AU POINT DE GAUSS CONSIDERE
! IN   NBRES  : NOMBRE DES COEFFICIENTS
! IN   NOMRES : NOM DES COEFFICIENTS
!
! OUT  VALRES : VALEURS DES COEFFICIENTS
! OUT  DEVRES : DERIVEE DES COEFFICIENTS
! OUT  ICODRE : POUR CHAQUE RESULTAT, 0 SI ON A TROUVE, 1 SINON
! ......................................................................
!
!
!
!
    integer :: nbobj, nbf, nbr, ivalr, ivalk, ir, idf, ires
    integer :: lmat, lfct, icomp, ipi, ifon, ik, nbmat, iret
    character(len=10) :: phen
!
! ----------------------------------------------------------------------
! PARAMETER ASSOCIE AU MATERIAU CODE
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    parameter  ( lmat = 9 , lfct = 10 )
! DEB ------------------------------------------------------------------
!
!
    phen = phenom
    nbmat=zi(jmat)
!     UTILISABLE SEULEMENT AVEC UN MATERIAU PAR MAILLE
    ASSERT(nbmat.eq.1)
    imat = jmat+zi(jmat+nbmat+1)
!
    do 30 ires = 1, nbres
        icodre(ires) = 1
30  end do
!
    do 40 icomp = 1, zi(imat+1)
        if (phen .eq. zk32(zi(imat)+icomp-1)(1:10)) then
            ipi = zi(imat+2+icomp-1)
            goto 888
        endif
40  end do
    call utmess('F', 'ELEMENTS2_63')
    goto 999
888  continue
!
    nbobj = 0
    nbr = zi(ipi)
    ivalk = zi(ipi+3)
    ivalr = zi(ipi+4)
    do 150 ir = 1, nbr
        do 140 ires = 1, nbres
            if (nomres(ires) .eq. zk16(ivalk+ir-1)) then
                valres(ires) = zr(ivalr-1+ir)
                devres(ires) = 0.d0
                icodre(ires) = 0
                nbobj = nbobj + 1
            endif
140      continue
150  end do
!
    if (nbobj .ne. nbres) then
        idf = zi(ipi)+zi(ipi+1)
        nbf = zi(ipi+2)
        call rcvarc(' ', 'TEMP', poum, fami, kpg,&
                    ksp, temp, iret)
        if (iret .eq. 0) then
            do 170 ires = 1, nbres
                do 160 ik = 1, nbf
                    if (nomres(ires) .eq. zk16(ivalk+idf+ik-1)) then
                        ifon = ipi+lmat-1+lfct*(ik-1)
                        call rcfode(ifon, temp, valres(ires), devres( ires))
                        icodre(ires) = 0
                    endif
160              continue
170          continue
        else
            do 180 ires = 1, nbres
                do 190 ik = 1, nbf
                    if (nomres(ires) .eq. zk16(ivalk+idf+ik-1)) then
                        ifon = ipi+lmat-1+lfct*(ik-1)
                        call rcfode(ifon, 0.d0, valres(ires), devres( ires))
                        icodre(ires) = 0
                    endif
190              continue
180          continue
        endif
    endif
!
999  continue
! FIN ------------------------------------------------------------------
end subroutine
