! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine gcou2d(base, resu, noma, nomno, noeud,&
                  coor, rinf, rsup, l_new_fiss)
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/cnocns.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/jeexin.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    real(kind=8) :: rinf, rsup, coor(*)
    character(len=1) :: base
    character(len=8) :: noma, noeud
    character(len=24) :: resu, nomno
    aster_logical, optional :: l_new_fiss
!
!
! FONCTION REALISEE:
!
!     OPTION COURONNE EN 2D
!     ---------------------
!
! 1.  POUR LE NOEUD DU FOND DE FISSURE ON RECUPERE
!     LE TRIPLET ( MODULE(THETA), RINF, RSUP )
!
! 2.  ENSUITE ON CALCUL THETA SUR TOUT LES NOEUDS DU MAILLAGE
!
!     ------------------------------------------------------------------
! ENTREE:
!        RESU   : NOM DU CONCEPT DE TYPE CHAM_NO
!        NOMA   : NOM DU MAILLAGE
!        NOMNO  : NOM DE L'OBJET CONTENANT LES NOEUDS DU MAILLAGE
!        NOEUD  : NOM DU NOEUD DU FOND DE FISSURE
!        COOR   : COORDONNEES DES NOEUDS
!        RINF   : RAYON INFERIEURE DE LA COURONNE
!        RSUP   : RAYON SUPERIEURE DE LA COURONNE
!        L_NEW_FISS : nouvelle SD FISSURE (provisoire)
!
! SORTIE:
!        DIR    : DIRECTION DU CHAMPS THETA NORMALISEE
!     ------------------------------------------------------------------
!
!
    integer :: itheta, i, irefe, idesc, num, nbel, numa
    integer :: nec, ibid, numfon, n1, n2, ndim, jgtl, estbf
    parameter     (ndim=2)
    real(kind=8) :: xm, ym, xi, yi, eps, d, norme, alpha, valx, valy, dir(3)
    character(len=8) :: k8b, fiss, fonfis
    character(len=19) :: grlt, chgrs
    character(len=24) :: chamno
    real(kind=8), pointer :: fondfiss(:) => null()
    real(kind=8), pointer :: cnsv(:) => null()
    real(kind=8), pointer :: vbasfd(:) => null()
    aster_logical :: estfem, l_new_fissure
!     ------------------------------------------------------------------
!
    call jemarq()
    eps = 1.d-06
    chgrs=''
    fiss=''
    fonfis=''
    l_new_fissure = ASTER_FALSE
    if(present(l_new_fiss)) then
        l_new_fissure = l_new_fiss
    end if
!
    n1=1
    n2=0
!
!   CAS CLASSIQUE (N1 NON NUL) OU CAS X-FEM (N2 NON NUL)
    call getvid('THETA', 'FOND_FISS', iocc=1, scal=fonfis, nbret=n1)
    call getvid('THETA', 'FISSURE', iocc=1, scal=fiss, nbret=n2)

!   TEST DU TYPE DE FISSURE ET RECUPERATION DU NUMERO DE NOEUD DU FOND DE FISSURE FEM
    estfem=.true.
    if (n1 .ne. 0 .or. l_new_fissure) then
        estfem=.true.
        call jenonu(jexnom(nomno, noeud), num)
    else if (n2 .ne. 0) then
        estfem=.false.
        num = 0
    end if
!
!     DANS LE CAS X-FEM, SI LA DIRECTION A ETE DONNEE, ON LA GARDE FIXE
!     SI ELLE N'A PAS ETE DONNEE, ON PREND UNE DIRECTION VARIABLE QUI
!     VAUT LE GRADIENT DE LA LEVEL SET TANGENTE

!     On verifie l'existence de basefond
    call jeexin(fonfis//'.BASEFOND', estbf)

!     --- LA DIRECTION DE THETA N'EST DONNEE, ON LA RECUPERE
!         DE BASEFOND CALCULE DANS DEFI_FOND_FISS. ---
    if (estfem) then
        if (estbf .eq. 0 .and. (.not.l_new_fissure)) then
           ! basefond n'existe pas
            call utmess('F', 'RUPTURE0_58')
        end if

        if(.not.l_new_fissure) then
            call jeveuo(fonfis//'.BASEFOND', 'L', vr=vbasfd)
            if (size(vbasfd).gt.4) then
            ! le front ne doit contenir qu'un noeud, donc 4 composantes dans basefond
            call utmess('F', 'RUPTURE0_33')
            end if
            norme = sqrt(vbasfd(3)**2+vbasfd(4)**2)
    !       Basefond contient 4*1 composantes (XN YN XP YP)i
    !       Avec N pour direction normale et P pour direction plan.
            dir(1) = vbasfd(3)/norme
            dir(2) = vbasfd(4)/norme
            dir(3) = 0.d0
        else
            call utmess('A', 'RUPTURE0_62')
            dir = [1.d0, 0.d0, 0.d0]
        end if
    endif
!
!  .DESC
    chamno = resu(1:19)//'.DESC'
    call dismoi('NB_EC', 'DEPL_R', 'GRANDEUR', repi=nec)
    call wkvect(chamno, base//' V I', 2+nec, idesc)
!
    call jeecra(chamno, 'DOCU', cval='CHNO')
    call jenonu(jexnom('&CATA.GD.NOMGD', 'DEPL_R'), numa)
    zi(idesc+1-1) = numa
    zi(idesc+2-1) = -2
    zi(idesc+3-1) = 6
!
!  .REFE
    chamno = resu(1:19)//'.REFE'
    call wkvect(chamno, base//' V K24', 4, irefe)
    zk24(irefe+1-1) = noma//'                '
!
!  .VALE
    chamno = resu(1:19)//'.VALE'
    call dismoi('NB_NO_MAILLA', noma, 'MAILLAGE', repi=nbel)
    call wkvect(chamno, base//' V R', 2*nbel, itheta)
!
!     --- CALCUL DE THETA ---
!
!     CAS CLASSIQUE
    if (estfem) then
!       NOEUD DU FOND DE FISSURE
        zr(itheta + (num-1)*2 + 1 - 1) = dir(1)
        zr(itheta + (num-1)*2 + 2 - 1) = dir(2)
        xi = coor((num-1)*3+1)
        yi = coor((num-1)*3+2)
!     CAS X-FEM
    else if (.not. estfem) then
        call getvis('THETA', 'NUME_FOND', iocc=1, scal=numfon, nbret=ibid)
        call jeveuo(fiss//'.FONDFISS', 'L', vr=fondfiss)
        xi = fondfiss(4*(numfon-1)+1)
        yi = fondfiss(4*(numfon-1)+2)
        call utmess('I', 'XFEM_10')
!         RÉCUPÉRATION DU GRADIENT DE LST
        grlt = fiss//'.GRLTNO'
        chgrs = '&&GCOU2D.GRLT'
        call cnocns(grlt, 'V', chgrs)
        call jeveuo(chgrs//'.CNSV', 'L', vr=cnsv)
        call jeveuo(chgrs//'.CNSL', 'L', jgtl)
    endif
!
!
! BOUCLE SUR LES AUTRES NOEUDS COURANTS DU MAILLAGE
!
    do i = 1, nbel
        if (i .ne. num) then
            xm = coor((i-1)*3+1)
            ym = coor((i-1)*3+2)
            d = sqrt((xi-xm)*(xi-xm)+(yi-ym)*(yi-ym))
            alpha = (d-rinf)/(rsup-rinf)
            if (.not. estfem) then
!           LE GRANDIENT EST DÉFINI
                if (zl(jgtl-1+ndim*(i-1)+1)) then
                    dir(1) = cnsv(ndim*(i-1)+1)
                    dir(2) = cnsv(ndim*(i-1)+2)
                    norme = sqrt(dir(1)**2+dir(2)**2)
                else
!           LE GRANDIENT N'EST PAS DÉFINI
                    dir(1) = 0.d0
                    dir(2) = 0.d0
                    norme = 1.d0
                endif
!           IL SE PEUT QUE EN CERTAINS POINTS, LE GRADIENT SOIT NUL
!           CES POINTS SONT NORMALEMENT HORS COURONNE THETA
                if (norme .le. r8prem()*1.d04) then
                    if ((abs(alpha-1).gt.eps) .and. ((alpha-1).le.0)) then
                        call jenuno(jexnum(noma//'.NOMNOE', i), k8b)
                        call utmess('F', 'XFEM_12', sk=k8b)
                    endif
                    norme = 1.d0
                endif
                dir(1) = dir(1)/norme
                dir(2) = dir(2)/norme
            endif
            valx = dir(1)
            valy = dir(2)
            if ((abs(alpha).le.eps) .or. (alpha.lt.0)) then
                zr(itheta+(i-1)*2+1-1) = valx
                zr(itheta+(i-1)*2+2-1) = valy
            else if ((abs(alpha-1).le.eps).or.((alpha-1).gt.0)) then
                zr(itheta+(i-1)*2+1-1) = 0.d0
                zr(itheta+(i-1)*2+2-1) = 0.d0
            else
                zr(itheta+(i-1)*2+1-1) = (1-alpha)*valx
                zr(itheta+(i-1)*2+2-1) = (1-alpha)*valy
            endif
        endif
    end do
!
    call detrsd('CHAM_NO_S', chgrs)
!
    call jedema()
end subroutine
