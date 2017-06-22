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

subroutine xprdis(fisref, fisdis, dist, tol, lcmin)
!
    implicit none
#include "jeveux.h"
#include "asterc/r8maem.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    character(len=8) :: fisref, fisdis
    real(kind=8) :: dist, tol, lcmin
!
! person_in_charge: samuel.geniaut at edf.fr
!
!     ------------------------------------------------------------------
!
!       XPRDIS   : X-FEM PROPAGATION : DISTANCE MAXIMALE ENTRE DEUX
!       ------     -     --            ---
!                  FONDS DE FISSURE
!
!    DISTANCE MAXIMALE ENTRE DEUX FONDS DE FISSURE EN 3D. ON CALCULE
!    LA DISTANCE ENTRE CHAQUE POINT DU FOND DE LA FISSURE FISDIS ET LE
!    FOND DE LA FISSURE FISREF. EN SORTIE, ON DONNE LA VALEUR MAXIMALE
!    CALCULEE.
!
!    ENTREE
!        FISREF : FISSURE DE REFERENCE
!                 (NOM DU CONCEPT FISSURE X-FEM)
!        FISDIS : FISSURE POUR LAQUELLE ON CALCULE LA DISTANCE MAXIMALE
!                 (NOM DU CONCEPT FISSURE X-FEM)
!        DIST   : DISTANCE ATTENDUE
!        TOL    : TOLERANCE SUR LA DISTANCE CALCULEE
!        LCMIN  : LONGUEUR DE LA PLUS PETITE ARETE DU MAILLAGE
!
!    AUCUNE SORTIE
!
!     ------------------------------------------------------------------
!
!
    integer :: ifm, niv,  nbptfr,  numfon,  nbptfd, i, j, fon
    real(kind=8) :: eps, xm, ym, zm, xi1, yi1, zi1, xj1, yj1, zj1, xij, yij, zij
    real(kind=8) :: xim, yim, zim, s, norm2, xn, yn, zn, d, dmin
    real(kind=8) :: dismin, dismax, difmin, difmax
    real(kind=8), pointer :: fond(:) => null()
    real(kind=8), pointer :: fonr(:) => null()
    integer, pointer :: fondmult(:) => null()
!
!-----------------------------------------------------------------------
!     DEBUT
!-----------------------------------------------------------------------
    call jemarq()
    call infmaj()
    call infniv(ifm, niv)
!
!     ---- FISREF ----
!
!     RETREIVE THE CRACK FRONT (FISREF)
    call jeveuo(fisref//'.FONDFISS', 'L', vr=fonr)
    call dismoi('NB_POINT_FOND', fisref, 'FISS_XFEM', repi=nbptfr)
!
!     RETRIEVE THE DIFFERENT PIECES OF THE CRACK FRONT
    call jeveuo(fisref//'.FONDMULT', 'L', vi=fondmult)
    call dismoi('NB_FOND', fisref, 'FISS_XFEM', repi=numfon)
!
!     ---- FISDIS ----
!
!     RETREIVE THE CRACK FRONT (FISDIF)
    call jeveuo(fisdis//'.FONDFISS', 'L', vr=fond)
    call dismoi('NB_POINT_FOND', fisdis, 'FISS_XFEM', repi=nbptfd)
!
!     ***************************************************************
!     EVALUATE THE PROJECTION OF EACH POINT OF FISDIF ON THE CRACK
!     FRONT FISREF
!     ***************************************************************
!
    dismin=r8maem()
    dismax=0.d0
!
!     BOUCLE SUR LES NOEUDS M DU MAILLAGE POUR CALCULER PROJ
    eps = 1.d-12
    do i = 1, nbptfd
!
!        COORDINATES OF THE POINT M OF THE FRONT FISDIS
        xm=fond(4*(i-1)+1)
        ym=fond(4*(i-1)+2)
        zm=fond(4*(i-1)+3)
!
!        INITIALISATION
        dmin = r8maem()
!
!        BOUCLE SUR PT DE FONFIS
        do j = 1, nbptfr
!
!           CHECK IF THE CURRENT SEGMENT ON THE FRONT IS OUTSIDE THE
!           MODEL (ONLY IF THERE ARE MORE THAN ONE PIECE FORMING THE
!           FRONT)
            do fon = 1, numfon
                if ((j.eq.fondmult(2*fon)) .and. (j.lt.nbptfr)) goto 210
            end do
!
!           COORD PT I, ET J
            xi1 = fonr(4*(j-1)+1)
            yi1 = fonr(4*(j-1)+2)
            zi1 = fonr(4*(j-1)+3)
!
            xj1 = fonr(4*(j-1+1)+1)
            yj1 = fonr(4*(j-1+1)+2)
            zj1 = fonr(4*(j-1+1)+3)
!
!           VECTEUR IJ ET IM
            xij = xj1-xi1
            yij = yj1-yi1
            zij = zj1-zi1
            xim = xm-xi1
            yim = ym-yi1
            zim = zm-zi1
!
!           PARAM S (PRODUIT SCALAIRE...)
            s = xij*xim + yij*yim + zij*zim
            norm2 = xij*xij + yij*yij + zij*zij
            ASSERT(norm2.gt.r8prem())
            s = s/norm2
!           SI N=P(M) SORT DU SEGMENT
            if ((s-1) .ge. eps) s = 1.d0
            if (s .le. eps) s = 0.d0
!
!           COORD DE N
            xn = s*xij+xi1
            yn = s*yij+yi1
            zn = s*zij+zi1
!
!           DISTANCE MN
!           SAVE CPU TIME: THE SQUARE OF THE DISTANCE IS EVALUATED!
            d = (xn-xm)*(xn-xm)+(yn-ym)*(yn-ym)+(zn-zm)*(zn-zm)
            if (d .lt. dmin) dmin=d
!
210         continue
        end do
!
        if (dmin .gt. dismax) dismax=dmin
        if (dmin .lt. dismin) dismin=dmin
!
    end do
!
    dismax=sqrt(dismax)
    dismin=sqrt(dismin)
!
!     CHECK IF THE TOLERANCE ON THE CALCULATED DISTANCE IS RESPECTED
    ASSERT(lcmin.gt.r8prem())
    difmin = (dismin-dist)/lcmin*100
    difmax = (dismax-dist)/lcmin*100
!
!     WRITE SOME INFORMATIONS
    write(ifm,*)
    write(ifm,*)'------------------------------------------------'
    write(ifm,*)'TEST SUR LA FORME DU FOND DE FISSURE PAR RAPPORT'
    write(ifm,*)'AU FOND INITIAL. LE NOUVEAU FOND DOIT ETRE'
    write(ifm,*)'HOMOTHETIQUE AU FOND INITIAL.'
    write(ifm,*)
    write(ifm,*)'LONGUEUR DE LA PLUS PETITE ARETE DU MAILLAGE:',lcmin
    write(ifm,901) tol
    write(ifm,*)
    write(ifm,*)'DISTANCE ATTENDUE ENTRE LES DEUX FONDS: ',dist
    write(ifm,*)'DISTANCE MINIMALE CALCULEE = ',dismin
    write(ifm,900) difmin
    write(ifm,*)'DISTANCE MAXIMALE CALCULEE = ',dismax
    write(ifm,900) difmax
    write(ifm,*)
    write(ifm,*)'L''ERREUR EST CALCULE PAR RAPPORT A LA LONGUEUR DE'
    write(ifm,*)'LA PLUS PETITE ARETE DU MAILLAGE.'
    write(ifm,*)
    if ((abs(difmin).le.tol) .and. (abs(difmax).le.tol)) then
!        OK. TEST PASSED.
        write(ifm,*)'RESULTAT DU TEST: OK.'
        write(ifm,*)'------------------------------------------------'
        write(ifm,*)
    else
!        TEST FAILED.
        call utmess('A', 'XFEM2_91')
    endif
!
    900 format('                     ERREUR = ',f6.1,'%')
    901 format(' TOLERANCE = ',f6.1,'%')
!
!-----------------------------------------------------------------------
!     FIN
!-----------------------------------------------------------------------
    call jedema()
end subroutine
