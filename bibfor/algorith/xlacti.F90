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

subroutine xlacti(typma, ninter, jaint, lact, nlact)
!
    implicit none
#include "jeveux.h"
#include "asterfort/conare.h"
#include "asterfort/xxmmvd.h"
    character(len=8) :: typma
    integer :: ninter, jaint, lact(8), nlact
!
! ----------------------------------------------------------------------
!
! ROUTINE XFEM
!
! ACTIVATION DES LAGRANGES POUR LA FORMULATION LAGRANGES AUX NOEUDS
! POUR CHAQUE NOEUD SOMMET,
!        LACT(INO)=0: LES DDL DE CONTACT DE CE NOEUD NE SONT PAS ACTIFS
!        LACT(INO)=NLI > 0: LES DDL DE CONTACT DE CE SOMMET SONT ACTIFS
!                       NLI EST LE NUMEROS DU PT D'INTERSECTION
!
! POUR OPTIMISER, ON PEUT SORTIR XLACTI DES TE'S, IL FAUT ALORS
! PASSER UN CHAMP SUPPLÉMENTAIRE AUX TE'S
!
! ----------------------------------------------------------------------
!
! IN  TYPMA  : TYPE  DE MAILLE DE L'ELEMENT PARENT
! IN  NINTER : NOMBRE DE POINTS D'INTERSECTION
! IN  JAINT  : ADRESSE DES INFORMATIONS CONCERNANT LES ARETES COUPÉES
! OUT LACT   : LISTE DES LAGRANGES ACTIFS
! OUT NLACT  : NOMBRE TOTAL DE LAGRANGES ACTIFS
!
!
!
!
    integer :: zxain
    integer :: ino, ino1, ino2, iar, ar(12, 3), nbar
    integer :: vit(8), nvit, nli
!.......................................................................
!
! --- INITIALISATIONS
!
    do 30 ino = 1, 8
        lact(ino) = 0
        vit(ino) = 0
30  end do
    nlact = 0
    call conare(typma, ar, nbar)
    zxain=xxmmvd('ZXAIN')
!
! --- ON ACTIVE LES NOEUDS CONNECTES AUX POINTS D'INTERSECTION
    do 10 nli = 1, ninter
        iar=int(zr(jaint-1+zxain*(nli-1)+1))
        ino=int(zr(jaint-1+zxain*(nli-1)+2))
        nvit=int(zr(jaint-1+zxain*(nli-1)+5))
        if (ino .gt. 0) then
            lact(ino)=nli
        else if (iar.gt.0) then
            ino1=ar(iar,1)
            ino2=ar(iar,2)
            if (nvit .eq. 1) then
                lact(ino1)=nli
                vit(ino1)=1
                lact(ino2)=nli
                vit(ino2)=1
            else
                if (vit(ino1) .eq. 0) lact(ino1)=nli
                if (vit(ino2) .eq. 0) lact(ino2)=nli
            endif
        endif
10  end do
! --- ON COMPTE LE NOMBRE DE NOEUDS ACTIFS
    do 20 ino = 1, 8
        if (lact(ino) .ne. 0) nlact=nlact+1
20  end do
!
end subroutine
