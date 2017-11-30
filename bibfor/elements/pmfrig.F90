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

subroutine pmfrig(nomte, icdmat, klv)
!
!
! --------------------------------------------------------------------------------------------------
!
!     CALCUL DE LA MATRICE DE RIGIDITE DES ELEMENTS DE POUTRE MULTIFIBRES
!
! --------------------------------------------------------------------------------------------------
!
!   IN
!       nomte   : nom du type element 'meca_pou_d_em' 'meca_pou_d_tgm'
!       icdmat  : adresse matériau codé
!
!   OUT
!       klv     : matrice de rigidité
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
#include "jeveux.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/jevech.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lonele.h"
#include "asterfort/pmfasseinfo.h"
#include "asterfort/pmfinfo.h"
#include "asterfort/pmfite.h"
#include "asterfort/pmfitg.h"
#include "asterfort/pmfitx.h"
#include "asterfort/pmfk01.h"
#include "asterfort/pmfk21.h"
#include "asterfort/pmpbkbsq.h"
#include "asterfort/poutre_modloc.h"
#include "asterfort/r8inir.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
!
    character(len=*) :: nomte
    integer :: icdmat
    real(kind=8) :: klv(*)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbasspou, maxfipoutre, jacf    
    integer :: i, ii, pos, posfib, ig, codres(4), icp, icompo, isdcom
    real(kind=8) :: g, xjx, gxjx, xl, casect(6), vs(6), val(4)
    real(kind=8) :: cars1(6), a, alfay, alfaz, ey, ez, xjg, skt(78)
    character(len=16) :: ch16        
    character(len=32) :: materi
!
    integer :: nbfibr, nbgrfi, tygrfi, nbcarm, nug(10)
! --------------------------------------------------------------------------------------------------
    integer, parameter :: nb_cara = 6
    real(kind=8) :: vale_cara(nb_cara)
    character(len=8) :: noms_cara(nb_cara)
    data noms_cara /'AY1','AZ1','EY1','EZ1','JX1','JG1'/
! --------------------------------------------------------------------------------------------------
    real(kind=8), pointer :: yj(:) => null(), zj(:) => null()
    real(kind=8), allocatable :: vfv(:,:),skp(:,:)
    real(kind=8), pointer :: vev(:) => null()
    integer, pointer :: nbfipoutre(:) => null()
    real(kind=8), pointer :: gxjxpou(:) => null()
! --------------------------------------------------------------------------------------------------
!   Poutres droites multifibres
    if ((nomte.ne.'MECA_POU_D_EM') .and. (nomte.ne.'MECA_POU_D_TGM') &
         .and. (nomte.ne.'MECA_POU_D_SQUE')) then
        ch16 = nomte
        call utmess('F', 'ELEMENTS2_42', sk=ch16)
    endif
!
!   recuperation des coordonnees des noeuds
    xl = lonele()
!
!   Appel intégration sur section et calcul g torsion
    call pmfitx(icdmat, 1, casect, g)
!   Constante de torsion à partir des caractéristiques générales des sections
    call poutre_modloc('CAGNPO', noms_cara, nb_cara, lvaleur=vale_cara)
!
    if (nomte .eq. 'MECA_POU_D_EM') then
        xjx = vale_cara(5)
        gxjx = g*xjx
!       Calcul de la matrice de rigidité locale, poutre droite à section constante
        call pmfk01(casect, gxjx, xl, klv)
    else if (nomte.eq.'MECA_POU_D_TGM') then
!       Récupération des caractéristiques des fibres
        call pmfinfo(nbfibr,nbgrfi,tygrfi,nbcarm,nug,jacf=jacf)
!
        call pmfitg(tygrfi, nbfibr, nbcarm, zr(jacf), cars1)
        a     = cars1(1)
        alfay = vale_cara(1)
        alfaz = vale_cara(2)
        xjx   = vale_cara(5)
        ey    = vale_cara(3)
        ez    = vale_cara(4)
        xjg   = vale_cara(6)
!
        call pmfk21(klv, casect, a, xl, xjx, xjg, g, alfay, alfaz, ey, ez)
    else if (nomte.eq.'MECA_POU_D_SQUE') then
        call pmfinfo(nbfibr,nbgrfi,tygrfi,nbcarm,nug,jacf=jacf,nbassfi=nbasspou)
        AS_ALLOCATE(vi= nbfipoutre, size=nbasspou)
        AS_ALLOCATE(vr= gxjxpou, size=nbasspou)
        call pmfasseinfo(tygrfi,nbfibr,nbcarm,zr(jacf),maxfipoutre,nbfipoutre, gxjxpou)
        AS_ALLOCATE(vr=yj, size=nbasspou)
        AS_ALLOCATE(vr=zj, size=nbasspou)
        AS_ALLOCATE(vr=vev, size=maxfipoutre) 
        allocate(skp(78,nbasspou)) 
        allocate(vfv(7,maxfipoutre))
        call r8inir(nbasspou*78, 0.d0, skp, 1)
        call jevech('PCOMPOR', 'L', icompo)
        call jeveuo(zk16(icompo-1+7), 'L', isdcom)       
        !   6 caractéristiques utiles par fibre : y z aire yp zp numgr
        !   Boucle sur les poutres
        pos=1
        posfib=0
        do i = 1, nbasspou
           yj(i)=zr(jacf+7*(pos-1)+4-1)
           zj(i)=zr(jacf+7*(pos-1)+5-1)
           call r8inir(maxfipoutre*7, 0.d0, vfv, 1)
           call r8inir(maxfipoutre, 0.d0, vev, 1)
           !Boucle sur les fibres de la poutre
           do ii = 1, nbfipoutre(i)
              !Construction des vecteurs corrigés sur une poutre
              posfib=pos+ii-1
              vfv(1,ii)=zr(jacf+7*(posfib-1)+1-1)-zr(jacf+7*(posfib-1)+4-1)
              vfv(2,ii)=zr(jacf+7*(posfib-1)+2-1)-zr(jacf+7*(posfib-1)+5-1)
              vfv(3,ii)=zr(jacf+7*(posfib-1)+3-1)
              ig = zr(jacf+7*(1-1)+7-1)
              icp=isdcom-1+(nug(ig)-1)*6
              materi=zk24(icp+2)(1:8)
              call rcvalb('RIGI', 1, 1, '+', icdmat, materi, 'ELAS', 0, ' ', [0.0d+0],&
                           1, 'E', val, codres, 0)
              if (codres(1) .eq. 1) then
                  call rcvalb('RIGI', 1, 1, '+', icdmat, materi, 'ELAS_FLUI', 0, ' ', [0.0d+0],&
                               1, 'E', val, codres, 1)
              endif
              vev(ii) = val(1)
           enddo
           !      Propriétes de section sur la poutre
           call pmfite(tygrfi, maxfipoutre, nbcarm, vfv, vev, vs)
           !      Matrice de rigidite de la poutre
           call pmfk01(vs, gxjxpou(i), xl, skt)
           do  ii = 1, 78
               skp(ii,i) = skt(ii)
           enddo
           pos=pos+nbfipoutre(i)
        enddo
        !   Matrice de rigidite de l element
        call pmpbkbsq(skp, nbasspou, yj, zj, klv)
!
        deallocate(vfv)    
        deallocate(skp) 
        AS_DEALLOCATE(vi=nbfipoutre)
        AS_DEALLOCATE(vr=gxjxpou)
        AS_DEALLOCATE(vr=vev)
        AS_DEALLOCATE(vr=yj)
        AS_DEALLOCATE(vr=zj)
    endif
!
end subroutine
