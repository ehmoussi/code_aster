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

subroutine ftang(fn, xlocal, vitloc, cfrotd, cfrots,&
                 ktang, ctang, iadher, oldvt, oldft,&
                 oldxlo, cost, sint, ftange, flocal,&
                 vt)
!
!***********************************************************************
! 01/01/91    G.JACQUART AMV/P61 47 65 49 41
!***********************************************************************
!     FONCTION  : CALCULE LA FORCE TANGENTIELLE DE CHOC
!
!-----------------------------------------------------------------------
!                             ARGUMENTS
! .________________.____.______________________________________________.
!        NOM        MODE                    ROLE
!  ________________ ____ ______________________________________________
!                         VARIABLES DU SYSTEME DYNAMIQUE MODAL
!  ________________ ____ ______________________________________________
!    FN             <--   FORCE NORMALE
!    XLOCAL         <--   POSITION DANS LE REPERE LOCAL
!    VITLOC         <--   VITESSE DANS LE REPERE LOCAL
!    CFROTD         <--   COEFFICIENT DE FROTTEMENT DYNAMIQUE
!    CFROTS         <--   COEFFICIENT DE FROTTEMENT STATIQUE
!    KTANG          <--   RAIDEUR TANGENTIEL DE CHOC
!    CTANG          <--   AMORTISSEUR TANGENTIEL DE CHOC
!    IADHER         <-->  INDICATEUR DE GLISSEMENT =0 GLISSEMENT
!    OLDVT          <-->  VITESSE DE GLISSEMENT AU PAS PRECEDENT
!    OLDFT          <-->  FORCE TANGENTIELLE DE DEBUT DE GLISSEMENT
!    OLDXLO         <-->  POSITION DE DEBUT DE GLISSEMENT
!    COST,SINT      <--   DIRECTION NORMALE A L'OBSTACLE
!    FTANGE          -->  FORCE TANGENTIELLE DE CHOC (MODULE)
!    FLOCAL          -->  FORCE TANGENTIELLE DE CHOC REP. LOCAL
!    VT              -->  VITESSE TANGENTIELLE DE CHOC REP. LOCAL
!-----------------------------------------------------------------------
    implicit none
#include "asterc/r8prem.h"
    integer :: iadher
    real(kind=8) :: vitloc(3), flocal(3), xlocal(3), oldxlo(3), vt(2)
    real(kind=8) :: fn, ftange(2), ktang, ctang, dxt(2)
    real(kind=8) :: cost, sint, oldft(2), oldvt(2), cfrots, cfrotd
!
!     CALCUL DE LA VITESSE TANGENTIELLE
!
!-----------------------------------------------------------------------
    real(kind=8) :: xnftan, xnorvt, xscal, eps
    eps   = r8prem()
!-----------------------------------------------------------------------
    vt(1) = -sint*vitloc(2) + cost*vitloc(3)
    vt(2) = vitloc(1)
!
!     TESTE CHANGEMENT DE SIGNE VITESSE TANGENTIELLE
!
    xscal=vt(1)*oldvt(1)+vt(2)*oldvt(2)
    xnorvt=sqrt(vt(1)**2+vt(2)**2)
    if (((xscal).ge.0.d0) .and. (iadher.eq.0) .and. (xnorvt.gt.1.d-6)) then
!
!       CAS DU GLISSEMENT
!
!       FORCE DE FROTTEMENT
!
        ftange(1)=-cfrotd*fn*vt(1)/xnorvt
        ftange(2)=-cfrotd*fn*vt(2)/xnorvt
        oldft(1)=ftange(1)
        oldft(2)=ftange(2)
        oldxlo(1)=xlocal(1)
        oldxlo(2)=xlocal(2)
        oldxlo(3)=xlocal(3)
    else
!
!       CAS DE L'ADHERENCE
!
!       DISTANCE DE GLISSEMENT
!
        dxt(1)=(-(xlocal(2)-oldxlo(2))*sint+(xlocal(3)-oldxlo(3))*&
        cost)
        dxt(2)= xlocal(1)-oldxlo(1)
!
!       FORCE DE FROTTEMENT
!
        iadher = 1
        ftange(1) = oldft(1) - ktang * dxt(1) - ctang * vt(1)
        ftange(2) = oldft(2) - ktang * dxt(2) - ctang * vt(2)
        xnftan=sqrt(ftange(1)**2+ftange(2)**2)
        if (xnftan .gt. (cfrots*fn)) then
            iadher = 0
            if (abs(xnorvt).le.eps) then
                ftange(1)=0.0d0
                ftange(2)=0.0d0
            else
                ftange(1)=-cfrotd*fn*vt(1)/xnorvt
                ftange(2)=-cfrotd*fn*vt(2)/xnorvt
            endif
            oldft(1)=ftange(1)
            oldft(2)=ftange(2)
            oldxlo(1)=xlocal(1)
            oldxlo(2)=xlocal(2)
            oldxlo(3)=xlocal(3)
        endif
    endif
    oldvt(1) = vt(1)
    oldvt(2) = vt(2)
!
!     CALCUL DE LA FORCE DANS LE REPERE LOCAL
!
    flocal(1)=ftange(2)
    flocal(2)=-ftange(1)*sint
    flocal(3)=ftange(1)*cost
end subroutine
