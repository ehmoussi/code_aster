! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine rcvalb(fami, kpg, ksp, poum, jmat, nomat,&
                  phenom, nbpar, nompar, valpar,&
                  nbres, nomres, valres, codret, iarret,nan)
!
use calcul_module, only : ca_jvcnom_, ca_nbcvrc_
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/rcvala.h"
#include "asterfort/rcvarc.h"
!
integer, intent(in) :: nbres
integer, intent(in) :: nbpar
character(len=*), intent(in) :: fami
integer, intent(in) :: kpg
integer, intent(in) :: ksp
character(len=*), intent(in) :: poum
integer, intent(in) :: jmat
character(len=*), intent(in) :: nomat
character(len=*), intent(in) :: phenom
character(len=*), intent(in) :: nompar(nbpar)
real(kind=8), intent(in) :: valpar(nbpar)
character(len=*), intent(in) :: nomres(nbres)
real(kind=8), intent(out) :: valres(nbres)
integer, intent(out) :: codret(nbres)
integer, intent(in) :: iarret
character(len=3), intent(in), optional :: nan

! ----------------------------------------------------------------------
! But : Recuperation des valeurs d'une liste de coefficients d'une relation de
!       comportement pour un materiau donne.
!       C'est une routine "chapeau" de rcvala.F90 pour ajouter les variables de commande
!
!     arguments d'entree:
!        jmat      : adresse de la liste des materiaux codes
!        nomat     : nom du materiau dans le cas d'une liste de materiaux
!                    si = ' ', on exploite le premier de la liste
!        phenom    : nom du phenomene (mot cle facteur sans le "_FO")
!        nbpar     : nombre de parametres dans nompar(*) et valpar(*)
!        nompar(*) : noms des parametres(ex: 'TEMP', 'INST' )
!        valpar(*) : valeurs des parametres
!        nbres     : nombre de coefficients recherches
!                    (dimension des tableaux nomres(*), valres(*) et icodre(*)
!        nomres(*) : nom des resultats (ex: 'E','NU',... )
!                    tels qu'il figurent dans la commande DEFI_MATERIAU
!       iarret = 0 : on remplit icodre et on sort sans message.
!              = 1 : si un des parametres n'est pas trouve, on arrete
!                       en fatal en indiquant le nom de la maille.
!              = 2 : idem que 1 mais on n'indique pas la maille.
!       nan    = 'OUI' (defaut) : pour les parametres non trouves, on retourne valres = NaN
!              = 'NON' : pour les parametres non trouves, on ne modifie pas valres
!
!     arguments de sortie:
!        valres(*) : valeurs des resultats apres recuperation et interpolation
!        icodre(*) : pour chaque resultat, 0 si on a trouve, 1 sinon
! ----------------------------------------------------------------------

    integer, parameter :: nbpamx=20
    integer :: nbpar2, ipar, nbpart, ier
    real(kind=8) :: valpa2(nbpamx), valvrc
    character(len=8) :: nompa2(nbpamx), novrc
! ----------------------------------------------------------------------

!   -- s'il n'y a pas de varc, il n'y a qu'a appeler  rcvala :
    if (ca_nbcvrc_ .eq. 0) then
        if (present(nan)) then
            call rcvala(jmat, nomat, phenom, nbpar, nompar,&
                    valpar, nbres, nomres, valres, codret,&
                    iarret, nan)
        else
            call rcvala(jmat, nomat, phenom, nbpar, nompar,&
                    valpar, nbres, nomres, valres, codret,&
                    iarret)
        endif
        goto 999
    endif


!   -- sinon, on ajoute les varc au debut de la liste des parametres
!      car fointa donne priorite aux derniers :
    nbpar2 = 0
    do ipar=1,ca_nbcvrc_
        novrc=zk8(ca_jvcnom_-1+ipar)
        call rcvarc(' ', novrc, poum, fami, kpg,&
                    ksp, valvrc, ier)
        if (ier .eq. 0) then
            nbpar2=nbpar2+1
            nompa2(nbpar2)=novrc
            valpa2(nbpar2)=valvrc
        endif
    enddo
    nbpart=nbpar+nbpar2
    ASSERT(nbpart .le. nbpamx)
    do ipar=1,nbpar
        nompa2(nbpar2+ipar) = nompar(ipar)
        valpa2(nbpar2+ipar) = valpar(ipar)
    enddo


    if (present(nan)) then
        call rcvala(jmat, nomat, phenom, nbpart, nompa2,&
                valpa2, nbres, nomres, valres, codret,&
                iarret,nan)
    else
        call rcvala(jmat, nomat, phenom, nbpart, nompa2,&
                valpa2, nbres, nomres, valres, codret,&
                iarret)
    endif

999 continue
end subroutine
