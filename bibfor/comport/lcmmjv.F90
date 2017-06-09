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

subroutine lcmmjv(mult_comp, nmat, cpmono, nbfsys, irota,&
                  itbint, nsg, hsr)
    implicit none
!     MONOCRISTAL : RECUPERATION DU MATERIAU A T(TEMPD) ET T+DT(TEMPF)
!     ----------------------------------------------------------------
!     IN  COMP   : OBJET COMPOR
!         NMAT   :  DIMENSION  MAXIMUM DE CPMONO
!     OUT CPMONO : NOMS DES LOIS POUR CHAQUE FAMILLE DE SYSTEME
!         NBFSYS : NOMBRE DE FAMILLES DE SYS GLIS
!         IROTA  : 1 POUR ROTATION DE RESEAU
!         ITBINT : 1 SI MATRICE D'INTERACTION DONNEE PAR L'UTILISATEUR
!         HSR    : MATRICE D'INTERACTION POUR L'ECROUISSAGE ISOTROPE
!                  UTILISEE SEULEMENT POUR LE MONOCRISTAL IMPLICITE
!     COMMON
!         TBSYSG : SYSTEMES DE GLISSEMENT DONNES PAR L'UTILISATEUR
!     ----------------------------------------------------------------
!     ----------------------------------------------------------------
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/r8inir.h"
#include "blas/dcopy.h"
    integer :: nmat, icompi, irota, itbint, icompo, nbfsys, i, j,  nsg
    integer :: icompr, nbsyst, nbtbsy, ifa, nbsysi, idecal
    real(kind=8) :: hsr(nsg, nsg), tbsysg
    character(len=16) :: mult_comp
    character(len=16) :: compk, compi, compr
    character(len=24) :: cpmono(5*nmat+1)
    common/tbsysg/tbsysg(900)
!     ----------------------------------------------------------------
!
! -   NB DE COMPOSANTES / VARIABLES INTERNES -------------------------
!
!
    call jemarq()
!
    compk=mult_comp(1:8)//'.CPRK'
    compi=mult_comp(1:8)//'.CPRI'
    compr=mult_comp(1:8)//'.CPRR'
    call jeveuo(compk, 'L', icompo)
    call jeveuo(compi, 'L', icompi)
!
    nbfsys=zi(icompi-1+5)
    irota =zi(icompi-1+6)
    itbint=zi(icompi-1+4)
    nbsyst=zi(icompi-1+8)
!
!     5 FAMILLES DE SYSTEMES MAXI
    do i = 1, 5*nbfsys
        cpmono(i)=zk24(icompo-1+i)
    end do
!
    cpmono(5*nbfsys+1)=zk24(icompo-1+5*nbfsys+1)
!
    nbtbsy=0
    do ifa = 1, nbfsys
        nbsysi=zi(icompi-1+8+ifa)
        nbtbsy=nbtbsy+nbsysi
    end do
!
    if (nbtbsy .ne. 0) then
        call r8inir(900, 0.d0, tbsysg, 1)
        call jeveuo(compr, 'L', icompr)
!           TABLE CONTENANT LES SYSTEMES
        call dcopy(6*nbtbsy+12, zr(icompr), 1, tbsysg, 1)
    else
        tbsysg(1)=0.d0
    endif
!     TABLE CONTENANT LA MATRICE D'INTERACTION
    if (itbint .eq. 1) then
        idecal=0
        if (nbtbsy .eq. 0) then
            call jeveuo(compr, 'L', icompr)
        endif
        idecal=nint(zr(icompr+1))
        do i = 1, nbsyst
            do j = 1, nbsyst
                hsr(i,j)=zr(icompr-2+idecal+nbsyst*(i-1)+j)
            end do
        end do
    endif
    call jedema()
end subroutine
