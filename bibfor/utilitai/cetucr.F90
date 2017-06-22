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

subroutine cetucr(motfac, model0)
! GRANDEURS CARACTERISTIQUES DE L'ETUDE - CREATION
!           *                     ***     **
!     ------------------------------------------------------------------
!      CREATION D'UNE TABLE CONTENANT LES GRANDEURS CARACTERISTIQUES
!      CONTENUES DANS LE MODELE
!      REMARQUE : LES GRANDEURS SONT LUES PAR LE SP
!
! IN  : MOTFAC  : MOT-CLE FACTEUR
! IN  : MODEL0  : NOM DE LA SD MODELE
!     ------------------------------------------------------------------
    implicit none
!
! DECLARATION PARAMETRES D'APPELS
! -------------------------------
#include "asterfort/getvr8.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/ltcrsd.h"
#include "asterfort/ltnotb.h"
#include "asterfort/tbajli.h"
#include "asterfort/tbajpa.h"
#include "asterfort/tbcrsd.h"
    character(len=*) :: motfac, model0
!     ------------------------------------------------------------------
!
!
! DECLARATION VARIABLES LOCALES
!
    integer :: nbpar
    parameter  ( nbpar = 2 )
    integer :: nbmcle
    parameter  ( nbmcle = 3 )
!     ------------------------------------------------------------------
    integer :: n1, ibid, iaux
    real(kind=8) :: vr
    complex(kind=8) :: cbid
    character(len=2) :: typpar(nbpar)
    character(len=8) :: nompar(nbpar)
    character(len=8) :: modele, vk
    character(len=8) :: nomgrd(nbmcle)
    character(len=16) :: motcle(nbmcle)
    character(len=19) :: table
!     ------------------------------------------------------------------
    data motcle / 'LONGUEUR', 'PRESSION', 'TEMPERATURE' /
    data nomgrd / 'LONGUEUR', 'PRESSION', 'TEMP' /
!     ------------------------------------------------------------------
!
    call jemarq()
    ibid=0
    cbid=(0.d0,0.d0)
!
    modele = model0
!
!====
! 1. ACCROCHAGE D'UNE LISTE DE TABLE A LA STRUCTURE 'MODELE'
!====
!
! 1.1 ==> CREATION D'UNE LISTE DE TABLE
!         REMARQUE : LA LISTE NE CONTIENT QU'UNE SEULE TABLE !
!
    call ltcrsd(modele, 'G')
!
! 1.2 ==> RECUPERATION DU NOM DE LA TABLE DANS LA LISTE
!
    call ltnotb(modele, 'CARA_ETUDE', table)
!
!====
! 2. REMPLISSAGE DE LA TABLE
!====
!
! 2.1. ==> CREATION D'UNE TABLE CONTENANT LES GRANDEURS CARACTERISTIQUES
!
    call tbcrsd(table, 'G')
!
    nompar(1)='GRANDEUR'
    typpar(1)='K8'
    nompar(2)='VALE'
    typpar(2)='R'
    call tbajpa(table, nbpar, nompar, typpar)
!
! 2.2. ==> LECTURE ET STOCKAGE DES VALEURS PRESENTES
!
    do iaux = 1 , nbmcle
        call getvr8(motfac, motcle(iaux), iocc=1, scal=vr, nbret=n1)
        if (n1 .gt. 0) then
            vk = nomgrd(iaux)
            call tbajli(table, nbpar, nompar, [ibid], [vr],&
                        [cbid], vk, 0)
        endif
    end do
!
    call jedema()
!
end subroutine
