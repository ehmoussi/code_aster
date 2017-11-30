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

subroutine pmfitsbts(typfib, nf, ncarf, vf, vsig, b, wi, nbassepou, yj, zj, maxfipoutre, &
                     nbfipoutre, vsigv, vfv, flp, ve)
!
!
! --------------------------------------------------------------------------------------------------
!
!   INTEGRATION DES CONTRAINTES SUR LA SECTION : CALCUL DES EFFORTS INTERIEURS
!
! --------------------------------------------------------------------------------------------------
!
!    IN
!       typfib        : type des fibres : 1 ou 2
!       nf            : nombre de fibres
!       ncarf         : nombre de caracteristiques sur chaque fibre
!       vf(*)         : positions des fibres
!           Types 1 et 2
!               vf(1,*) : Y fibres
!               vf(2,*) : Z fibres
!               vf(3,*) : Aire fibres
!           Types 2
!               vf(4,*) : Yp groupes de fibres
!               vf(5,*) : Zp groupes de fibres
!               vf(6,*) : num du groupe
!       vsig(*)       : contrainte normale dans chaque fibre
!       b             : deformations generalisees
!       wi            : poids du point d'integration
!       nbassepou     : nombre de sous-poutres si multipoutre
!       yj(*)         : position Y des sous-poutres
!       zj(*)         : position Z des sous-poutres
!       maxfipoutre   : nombre maximum de fibres dans les sous-poutres
!       nbfipoutre(*) : nombre de fibres dans les sous-poutres
!       vsigv(*)      : tableau vide afin de decrire vsig(*) sur une sous-poutre
!       vfv(*)        : tableau vide afin de decrire vf(*) sur une sous-poutre
!
!   OUT
!       flp(12,*) : tableau de forces elementaires sur sous-poutres
!       ve(*)    : forces elementaires
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
#include "asterfort/utmess.h"
#include "asterfort/pmfits.h"
#include "asterfort/pmfbts.h"
#include "asterfort/pmpitp.h"
#include "asterfort/r8inir.h"
!
    integer :: typfib, nf, ncarf, nbassepou, maxfipoutre, nbfipoutre(*)
    real(kind=8) :: vf(ncarf, nf), vsig(nf), vs2(3), b(4), wi, ve(*), vet(12),  vs(6)

!
! --------------------------------------------------------------------------------------------------
!
    integer :: ii, i, pos, posfib
    real(kind=8) :: yj(*), zj(*), flp(12,*)
    real(kind=8) :: vfv(7,*), vsigv(*)
!
! --------------------------------------------------------------------------------------------------
!
    vs(:)=0.0d0
!
    if ( typfib .eq. 1 ) then          
        call r8inir(12, 0.d0, ve, 1)
!       3 caractéristiques utiles par fibre : y z aire
        call pmfits(typfib, nf, ncarf, vf, vsig, vs)
        call pmfbts(b, wi, vs, ve)
    else if ( (typfib .eq. 2) .or. (typfib .eq. 3) ) then
        vet(:)=0.d0
        vs(:)=0.d0
        vs2(:)=0.d0
        call r8inir(maxfipoutre, 0.d0, yj, 1)
        call r8inir(maxfipoutre, 0.d0, zj, 1)
        call r8inir(maxfipoutre, 0.d0, vsigv, 1)
!       Boucle sur les poutres
        pos=1
        do i = 1, nbassepou
          call r8inir(maxfipoutre*7, 0.d0, vfv, 1)
          !Position de la poutre
          yj(i)=vf(4,pos)
          zj(i)=vf(5,pos)
          !Boucle sur les fibres de la poutre
          do ii = 1, nbfipoutre(i)
            !Construction des vecteurs corrigés sur une sous-poutre
            posfib=pos+ii-1
            vfv(1,ii)=vf(1,posfib)-yj(i)
            vfv(2,ii)=vf(2,posfib)-zj(i)
            vfv(3,ii)=vf(3,posfib)
            vsigv(ii) = vsig(posfib)
          enddo
!         Integration des efforts de la sous-poutre sur la section
          call pmfits(typfib, maxfipoutre, ncarf, vfv, vsigv, vs)
!         Transfert aux noeuds
          call pmfbts(b, wi, vs, vet) 
          do  ii = 1, 12
              flp(ii,i) = vet(ii)
          enddo
          pos=pos+nbfipoutre(i)
        enddo
!       Calcul des efforts sur l element a partir des efforts sur les sous-poutres
        call pmpitp(typfib,flp, nbassepou, yj, zj, ve)

    else
      call utmess('F', 'ELEMENTS2_40', si=typfib)
    endif
!
end subroutine
