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

subroutine prekpr(modmec, mtrmas, nbddl, numer, mailla,&
                  chamat, celem)
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: nbddl
    character(len=8) :: modmec, mtrmas, numer, mailla, chamat, celem
!
!  BUT: RECHERCHE DES MATRICES ELEMENTAIRES POUR LA REPONSE EFFO_ELNO
!       DU CALCUL DYNAMIQUE ALEATOIRE
!
! IN  : MODMEC : CONCEPT MODE_MECA
! OUT : MTRMAS : MATRICE MASSE
! OUT : NBDDL  : NOMBRE DE DDLS DU PROBLEME
! OUT : NUMER  : CONCEPT NUMEROTATION
! OUT : MAILLA : CONCEPT MAILLAGE
! OUT : CHAMAT : CHAMP MATER
! OUT : CELEM  : CARA_ELEM
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
!
!---------CONSTITUTION DE LA LISTE COMPLETE DES ET DDLS EN CAS D EFFORT
!---------RECUPERATION MODELE ET MAILLA
!
    call jemarq()
!
!
!
    call dismoi('REF_MASS_PREM', modmec, 'RESU_DYNA', repk=mtrmas, arret='C')
    call dismoi('NB_EQUA', mtrmas, 'MATR_ASSE', repi=nbddl)
    call dismoi('NOM_NUME_DDL', mtrmas, 'MATR_ASSE', repk=numer)
    call dismoi('NOM_MAILLA', mtrmas, 'MATR_ASSE', repk=mailla)
    call dismoi('CHAM_MATER', mtrmas, 'MATR_ASSE', repk=chamat)
    call dismoi('CARA_ELEM', mtrmas, 'MATR_ASSE', repk=celem)
!
    call jedema()
end subroutine
