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

subroutine askcyc(craid, ndim, soumat, beta, ni,&
                  nj, na, axok, liax, nbliax,&
                  libid)
    implicit none
!
!***********************************************************************
!    P. RICHARD     DATE 14/03/91
!-----------------------------------------------------------------------
!  BUT:  ASSEMBLER LES MATRICES RAIDEUR COMPLEXES RELATIVES
!   A UN PROBLEME CYCLIQUE SOUS MATRICES ET DEPHASAGE BETA
!
! METHODE:
!         TOUTES LES SOUS-MATRICES POSSIBLES SONT PASSEE  EN REVUE
!         PAR APPEL A DES ROUTINES D'ASSEMBLAGE SPECIALISEES
!         QUI TESTENT L'EXISTENCE DE LA SOUS-MATRICE ET NE FONT
!         RIEN SI ELLE N'EXISTE PAS
!         CHAQUE METHODE: CRAIG-BAMPTON (CB), MAC-NEAL (MN), ET
!                         CRAIG-BAMPTON HARMONIQUE (CBH) Y
!                         TROUVE SON COMPTE
!
!-----------------------------------------------------------------------
!
! CRAID    /O/: MATRICE DE RAIDEUR COMPLEXE
! NDIM     /O/: DIMENSION DES MATRICES COMPLEXES
! SOUMAT   /I/: NOM K24 DE LA FAMILLE DES SOUS-MATRICES
! BETA     /I/: ANGLE DE PEPHASAGE EN RADIANS
! NI       /I/: NOMBRE DE MODE PROPRES DE LA BASE
! NJ       /I/: NOMBRE DE DDL GENERALISES DE DROITE
! AXOK     /I/: FLAG ASSEMBLAGE TERMES RELATIFS DDL AXE
! LIAX     /I/: LISTE DES NUMERO DDL AXE A ASSEMBLER
! NBLIAX   /I/: NOMBRE DES DDL AXE A ASSEMBLER (<=NA)
! LIBID    /I/: LISTE BIDON LIBID(I)=I DE DIM >=MAX(NI,NJ)
!
!-----------------------------------------------------------------------
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/acyel1.h"
#include "asterfort/acyel2.h"
#include "asterfort/acyel4.h"
#include "asterfort/acyelt.h"
!
    character(len=24) :: soumat
    complex(kind=8) :: craid(*)
    integer :: nbliax, libid(*), liax(nbliax)
    aster_logical :: axok, vrai, faux
    integer :: i, ia, ibid, id, na, ndim
    integer :: ni, nj
    real(kind=8) :: beta
!-----------------------------------------------------------------------
    data vrai,faux /.true._1,.false./
!-----------------------------------------------------------------------
!
!
!
!-----------------MISE A ZERO DES MATRICES COMPLEXES--------------------
!
    ibid=0
    do 10 i = 1, ndim*(ndim+1)/2
        craid(i)=dcmplx(0.d0,0.d0)
 10 end do
!
!
!--------------DETERMINATION DES DIMENSIONS DES SOUS-MATRICES-----------
!
!
! DEBUT DES DDL GENERALISES DE DROITE
!
    id=ni+1
!
!  NOMBRE DE DDL GENERALISES INTERFACE AXE
!
!
! DEBUT DES DDL GENERALISES DE AXE
!
    ia=ni+nj+1
!
!
!-----------------ASSEMBLAGE TERMES STANDARDS--------------------------
!
!  POUR TOUTES LES METHODES
!
    call acyelt(soumat, 'K0II', ni, craid, ndim,&
                1, 1, 1.d0)
!
    call acyelt(soumat, 'K0JJ', nj, craid, ndim,&
                id, id, 1.d0)
!
    call acyel4(soumat, 'KPLUSJJ', nj, nj, faux,&
                [ibid], 0, [ibid], 0, craid,&
                ndim, id, id, beta)
!
!
!
!  POUR CRAIG-BAMPTON ET CRAIG-BAMPTON HARMONIQUE
!
    call acyel2(soumat, 'K0IJ', ni, nj, faux,&
                [ibid], 0, [ibid], 0, craid,&
                ndim, 1, id, 1.d0)
!
    call acyel4(soumat, 'KPLUSIJ', ni, nj, faux,&
                [ibid], 0, [ibid], 0, craid,&
                ndim, 1, id, beta)
!
!
!  POUR MAC-NEAL
!
    call acyel2(soumat, 'K0JI', nj, ni, faux,&
                [ibid], 0, [ibid], 0, craid,&
                ndim, id, 1, 1.d0)
!
    call acyel4(soumat, 'KPLUSJI', nj, ni, faux,&
                [ibid], 0, [ibid], 0, craid,&
                ndim, id, 1, beta)
!
!
!-------------------------CAS DE PRESENCE DE DDL AXE--------------------
!
    if (axok) then
!
!
!  POUR TOUTES LES METHODES
!CRAID,NDIM,IA
!
        call acyel1(soumat, 'K0AA', na, na, vrai,&
                    liax, nbliax, liax, nbliax, craid,&
                    ndim, ia, ia, 1.d0)
        call acyel2(soumat, 'K0AJ', na, nj, vrai,&
                    liax, nbliax, libid, nj, craid,&
                    ndim, ia, id, 1.d0)
        call acyel4(soumat, 'KPLUSAJ', na, nj, vrai,&
                    liax, nbliax, libid, nj, craid,&
                    ndim, ia, id, beta)
        call acyel4(soumat, 'KPLUSJA', nj, na, vrai,&
                    libid, nj, liax, nbliax, craid,&
                    ndim, id, ia, beta)
        call acyel4(soumat, 'KPLUSAA', na, na, vrai,&
                    liax, nbliax, liax, nbliax, craid,&
                    ndim, ia, ia, beta)
!
!
!  POUR CRAIG-BAMPTON ET CRAIG-BAMPTON HARMONIQUE
!
        call acyel2(soumat, 'K0IA', ni, na, vrai,&
                    libid, ni, liax, nbliax, craid,&
                    ndim, 1, ia, 1.d0)
        call acyel4(soumat, 'KPLUSIA', ni, na, vrai,&
                    libid, ni, liax, nbliax, craid,&
                    ndim, 1, ia, beta)
!
!
!  POUR MAC-NEAL
!
        call acyel2(soumat, 'K0AI', na, ni, vrai,&
                    liax, nbliax, libid, ni, craid,&
                    ndim, ia, 1, 1.d0)
        call acyel4(soumat, 'KPLUSAI', na, ni, vrai,&
                    liax, nbliax, libid, ni, craid,&
                    ndim, ia, 1, beta)
!
    endif
!
!
end subroutine
