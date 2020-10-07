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
!
! person_in_charge: nicolas.pignet at edf.fr
!
subroutine cgComputeTheta(cgField, cgTheta)
!
use calcG_type
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/cnscno.h"
#include "asterfort/cnscre.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/gcou2d.h"
#include "asterfort/ismali.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
#include "asterfort/utmess.h"
#include "asterfort/imprsd.h"
!
    type(CalcG_field), intent(in) :: cgField
    type(CalcG_theta), intent(inout) :: cgTheta

    integer :: i
    integer :: nbel, iret
    integer :: itheta, ibas, jcnsl

    real(kind=8) :: d, xm, ym, zm, xn, yn, zn, eps, alpha, lonfis

    character(len=2) :: licmp(6)
    character(len=24) :: cnstet
    real(kind=8) :: theta0
    data  licmp /'X1','X2','X3','X4','X5','X6'/
!
! --------------------------------------------------------------------------------------------------
!
!     CALC_G --- Utilities
!
!    Compute Theta Field in 2D and 3D
!    X-FEM not taken in charge for now
!
!    Contenu de theta: structure de données stockant les informations 
!            permettant de calculer le champ theta aux points de Gauss 
!            d'un élémentdans les te.
!            Le champ stocké dans jeveux sous le nom
!            cgTheta%theta_factors//"_CHAM_THETA_FACT".
!             
!            Les composantes de ce champ sont, pour chaque noeud :
!               - 1: la valeur de la fonction theta0(r) pour ce noeud,
!                    où r est la distance entre le noeud et son projeté
!                    sur le fond de fissure.
!               - 2 à 4: le vecteur t donnant la direction et le sens de
!                        theta pour ce noeud, associé au projeté du noeud
!                        sur le fond de fissure.
!               - 5: l'abscisse curviligne du projeté du noeud sur le
!                    fond de fissure. (3D uniquement)
!               - 6: longueur de la fissure. (3D uniquement)
!
!    Remplissage de la variable cgTheta%nb_theta_field
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    eps = 1.d-06
    lonfis=0
!
    call jeveuo(cgTheta%crack//'.BASLOC    .VALE', 'L', ibas)
!
    call dismoi('NB_NO_MAILLA', cgTheta%mesh, 'MAILLAGE', repi=nbel)
!
    if(cgField%level_info>1) then
        call utmess('I', 'RUPTURE3_2')
    end if
    
    do i = 1, nbel
        if(cgTheta%abscur(i).ge.lonfis) lonfis=cgTheta%abscur(i)
    enddo
!
    if(cgTheta%lxfem) then
        ! CAS X-FEM NON TRAITE ACTUELLEMENT
        ASSERT(ASTER_FALSE)
    else
        ! CAS FEM
        ! Vérifications spécifiques en 3D
        if (cgField%ndim .eq. 3) then
            ! VERIFICATION PRESENCE NB_POINT_FOND
            if (cgTheta%nb_point_fond .ne. 0) then
                ! NB_POINT_FOND .ne. 0 non pris en charge pour l'instant : issue30288
                ASSERT(.FALSE.)
                ! INTERDICTION D AVOIR NB_POINT_FOND AVEC
                ! DISCTRETISATION =  LEGENDRE
                if (cgTheta%discretization.eq.'LEGENDRE') then
                    call utmess('F', 'RUPTURE1_73')
                endif
            endif
        endif
        !
        ! DETERMINATION DU NOMBRE nb_theta_field DE CHAMP_NO THETA 
        if(cgField%ndim .eq. 2) then
            cgTheta%nb_theta_field=1
        else
            if (cgTheta%discretization.eq.'LINEAIRE') then
                if(cgTheta%nb_point_fond.ne.0)then
                    cgTheta%nb_theta_field = cgTheta%nb_point_fond
                else
                    cgTheta%nb_theta_field = cgTheta%nb_fondNoeud
                endif
            elseif(cgTheta%discretization.eq.'LEGENDRE') then
                cgTheta%nb_theta_field = cgTheta%degree + 1
            else
                ASSERT(.FALSE.)
            endif
        endif
!        
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!   NOUVELLE ECRITURE A TRAVERS LE CHAMP THETA_FACTORS
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    !
    ! allocation de la structure de données temporaire de theta

    !   N.B.: le champ theta contient seulement les ndimte champs utiles
    !     * stockage des champs simples utilisés pour le remplissages
    !
        cnstet = '&&CNSTET_CHAM'
        call cnscre(cgTheta%mesh,'NEUT_R',6,licmp,'V',cnstet)
        call jeveuo(cnstet(1:19)//'.CNSL','E',jcnsl)
        call jeveuo(cnstet(1:19)//'.CNSV','E',itheta)

!       BOUCLE SUR LES NOEUDS M COURANTS DU MAILLAGE
        do i = 1, nbel
!           CALCUL DE LA FONCTION DETERMINANT LA NORME DE THETA EN
!           FONTION DE R_INF, R_SUP ET LA DISTANCE DU NOEUD AU FRONT
!
!           COORDONNEES DU NOEUD COURANT M
            xm = cgTheta%coorNoeud((i-1)*3+1)
            ym = cgTheta%coorNoeud((i-1)*3+2)
            zm =0
!
            if(cgField%ndim .eq. 3) then
                zm= cgTheta%coorNoeud((i-1)*3+3)
            endif
!
!           COORDONNEES DU PROJETE N DE CE NOEUD SUR LE FRONT DE FISSURE 
            xn = zr(ibas-1+3*cgField%ndim*(i-1)+1)
            yn = zr(ibas-1+3*cgField%ndim*(i-1)+2)
            zn =0
            if(cgField%ndim .eq. 3) then
                zn= zr(ibas-1+3*cgField%ndim*(i-1)+3)
            endif
            d = sqrt((xn-xm)*(xn-xm)+(yn-ym)*(yn-ym)+(zn-zm)*(zn-zm))
            alpha = ( d- cgTheta%r_inf)/(cgTheta%r_sup-cgTheta%r_inf)
            
!           calcul de theta0 du noeud i
            if ((abs(alpha).le.eps) .or. (alpha.lt.0)) then
                theta0 = 1.d0
            else if((abs(alpha-1).le.eps).or.((alpha-1).gt.0)) then
                theta0 = 0.d0
            else
                theta0 = 1.d0-alpha
            endif

!           stockage de la norme de theta, évaluée au noeud i
            zl(jcnsl-1+6*(i-1)+1)=.true.
            zr(itheta-1+(i-1)*6+1) = theta0

!           stockage de t, la direction de theta, pour le noeud i issue de BASLOC
            zl(jcnsl-1+6*(i-1)+2)=.true.
            zl(jcnsl-1+6*(i-1)+3)=.true.
            zl(jcnsl-1+6*(i-1)+4)=.true.
            zr(itheta-1+(i-1)*6+2) = zr(ibas-1+ 3*cgField%ndim*(i-1)+2*cgField%ndim+1)
            zr(itheta-1+(i-1)*6+3) = zr(ibas-1+ 3*cgField%ndim*(i-1)+2*cgField%ndim+2)
            if(cgField%ndim .eq. 2) then
                zr(itheta-1+(i-1)*6+4) = 0
            else
                zr(itheta-1+(i-1)*6+4) = zr(ibas-1+ 3*cgField%ndim*(i-1)+2*cgField%ndim+3)
            endif
!
!           stockage de l'abscisse curviligne s, pour le noeud i en 3D
            zl(jcnsl-1+6*(i-1)+5)=.true.
            if(cgField%ndim .eq. 2) then
                zr(itheta-1+(i-1)*6+5) = 0 
            else
                zr(itheta-1+(i-1)*6+5) = cgTheta%abscur(i)
            endif
!
!           stockage de la longueur de la fissure, utile en 3D seulement
            zl(jcnsl-1+6*(i-1)+6)=.true.
            if(cgField%ndim .eq. 2) then
                zr(itheta-1+(i-1)*6+6) = 0
            else
                zr(itheta-1+(i-1)*6+6) = lonfis
            endif
        end do
    endif
!
!   ALLOCATION DES OBJETS POUR STOCKER LE VRAI CHAMP_NO THETA_FACTORS 
!
    cgTheta%theta_factors = cgTheta%theta_factors(1:8)//'_CHAM_THETA_FACT'
    call cnscno(cnstet,' ','OUI','V',cgTheta%theta_factors,'F',iret)
    call detrsd('CHAM_NO_S',cnstet)
!~     call imprsd('CHAMP', cgTheta%theta_factors, 6, ' VECTEUR THETA FACTORS')

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!   ECRITURE OLD SCHOOL CONSERVEE POUR LINSTANT > CHAMPS STOCKES DANS cgTheta%theta_field
!   A SUPPRIMER QUAND LA SORTIE DU CHAMPS THETA SERA MISE A JOUR
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    if (cgField%ndim .eq. 2) then
!
       call gcou2d('G', cgTheta%theta_field, cgTheta%mesh, cgTheta%nomNoeud, cgTheta%fondNoeud(1), &
                    cgTheta%coorNoeud, cgTheta%r_inf, cgTheta%r_sup, ASTER_TRUE)
        cgTheta%nb_theta_field = 1
    elseif (cgField%ndim .eq. 3) then
        !
        ! if(cgTheta%lxfem) then
        !   ASSERT(ASTER_FALSE)
        !     call gcour3(cgTheta%theta, cgTheta%mesh, cgTheta%coorNoeud, cgTheta%nb_fondNoeud, &
        !             trav1, &
        !             trav2, trav3, chfond, cgTheta%l_closed, grlt,&
        !             cgTheta%discretization, basfon, cdTheta%nombre, milieu,&
        !             ndimte, cdTheta%nombre, cgTheta%crack)
        ! else
        !     call gcour2(cgTheta%theta, cgTheta%mesh, cgTheta%nomNoeud, cgTheta%coorNoeud,&
        !             cdTheta%nb_fondNoeud, trav1, trav2, trav3, cgTheta%fon, chfond, basfon,&
        !             cgTheta%crack, cgTheta%l_closed, stok4, cgTheta%discretization,&
        !             cdTheta%nombre, milieu, ndimte, norfon)
        ! end if
!
        cgTheta%nb_theta_field = 0
    else
        ASSERT(ASTER_FALSE)
    endif

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!   FIN ECRITURE OLD SCHOOL CONSERVEE POUR LINSTANT
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


    call jedema()
end subroutine
