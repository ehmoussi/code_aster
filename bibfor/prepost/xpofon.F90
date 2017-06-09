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

subroutine xpofon(modele, mftot, nftot, nfcomf, ngfon)
    implicit none
!
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ltnotb.h"
#include "asterfort/utmess.h"
!
    character(len=8) :: modele
    integer :: mftot, nftot, nfcomf, ngfon
!     BUT : RECUPERER POUR L'IMPRESSION LES CARACTERISTIQUES DES FONDS
!           DE FISSURE
!   IN
!       MODELE : MODELE FISSURE
!       MAXFEM : MAILLAGE FISSURE
!   OUT
!       MFTOT  : NOMBRE TOTAL DE MAILLES DE FONDS DE FISSURES
!       NFTOT  : NOMBRE TOTAL DE NOEUDS DE FONDS DE FISSURES
!       NFCOMF : NOMBRE TOTAL DE CONNEXIONS DANS LES MAILLES
!       NGFON  : NOMBRE TOTAL DE FOND DE FISSURES
!     =================================================================
!     ------------------------------------------------------------------
    integer :: jnom,  jnfond
    integer :: iret, ifiss, ifon
    integer :: ndim, nfiss, nfond, nbnol
    character(len=8) :: fiss, mo, malini
    character(len=16) :: typdis
    character(len=19) :: nomta1, nomta2
    character(len=24) :: nom
    integer, pointer :: tbnp(:) => null()
    integer, pointer :: fondmult(:) => null()
!
!
!     INITIALISATIONS
    mftot = 0
    nftot = 0
    nfcomf = 0
    ngfon = 0
!
!     RECUPERATION DU NOMBRE DE FISSURES
    mo = modele
    nom = mo//'.FISS                   '
    call jeveuo(nom, 'L', jnom)
    call jelira(nom, 'LONUTI', nfiss)
!
!     RECUPERATION DES CARACTERISTIQUES DU MAILLAGE INITIAL
    call dismoi('NOM_MAILLA', mo, 'MODELE', repk=malini)
    call dismoi('DIM_GEOM', mo, 'MODELE', repi=ndim)
    if (.not.(ndim.eq.2.or.ndim.eq.3)) then
        call utmess('F', 'MODELISA2_6')
    endif
!
    if (ndim .eq. 2) then
!
        do ifiss = 1, nfiss
            fiss = zk8(jnom)
            call jeexin(fiss//'.FONDFISS', iret)
            if (iret .ne. 0) then
                call ltnotb(fiss, 'NB_FOND_FISS', nomta1)
                call jeveuo(nomta1//'.0001', 'L', jnfond)
                nfond = zi(jnfond)
                ngfon = ngfon + nfond
                nftot = nftot + nfond
                mftot = mftot + nfond
                nfcomf = nfcomf + nfond
            endif
        end do
!
    else if (ndim.eq.3) then
!
        do ifiss = 1, nfiss
!
            fiss = zk8(jnom)
            call dismoi('TYPE_DISCONTINUITE',fiss,'FISS_XFEM',repk=typdis)
            call jeexin(fiss//'.FONDFISS', iret)
            if (iret .ne. 0.and.typdis.eq.'FISSURE') then
!
                call jeveuo(fiss//'.FONDMULT', 'L', vi=fondmult)
!
                call ltnotb(fiss, 'NB_FOND_FISS', nomta1)
                call jeveuo(nomta1//'.0001', 'L', jnfond)
!
                call ltnotb(fiss, 'FOND_FISS', nomta2)
                call jeveuo(nomta2//'.TBNP', 'L', vi=tbnp)
!
                nfond = zi(jnfond)
                ngfon = ngfon + nfond
                do ifon = 1, nfond
                    nbnol = fondmult(1+ 2*ifon -1) - fondmult(1+ 2* ifon -2)
                    if (nbnol .ne. 0) then
                        mftot = mftot + nbnol
                        nfcomf = nfcomf + 2*nbnol
                    else
!               SI MAILLE POI1 EN 3D
                        mftot = mftot + 1
                        nfcomf = nfcomf + 1
                    endif
                end do
                nftot = nftot + tbnp(2)
!
            endif
        end do
    endif
!
end subroutine
