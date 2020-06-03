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

subroutine lc0003(fami,   kpg,  ksp,    ndim,   imate,  &
                  compor, crit, instam, instap, epsm,   &
                  deps,   sigm, vim,    option, angmas, &
                  sigp,   vip,  typmod, icomp,  nvi,    &
                  dsidep, codret)
!
! --------------------------------------------------------------------------------------------------
!
!                       LOI DE COMPORTEMENT ÉLASTIQUE A ÉCROUISSAGE
!
!                               CINÉMATIQUE LINÉAIRE
!                               CINÉMATIQUE LINÉAIRE + ISOTROPE
!
!      RELATIONS :  'VMIS_CINE_LINE'    en  3D  C_PLAN
!                   'VMIS_CINE_GC'      en      C_PLAN
!                   'VMIS_ECMI_LINE'    en  3D  C_PLAN
!                   'VMIS_ECMI_TRAC'    en  3D  C_PLAN
!
! --------------------------------------------------------------------------------------------------
!
! IN
!   fami        famille de point de gauss (rigi,mass,...)
!   kpg, ksp    numéro du (sous)point de gauss
!   ndim        dimension de l espace (3d=3,2d=2,1d=1)
!   typmod      type de modélisation
!   imate       adresse du matériau code
!   compor      comportement de l'élément
!                   compor(1) = relation de comportement
!                   compor(2) = nb de variables internes
!                   compor(3) = type de déformation
!   crit        critères  locaux
!                   crit(1) = nombre d'itérations maxi a convergence (iter_inte_maxi == itecrel)
!                   crit(2) = type de jacobien a t+dt (type_matr_comp == macomp)
!                                   0 = en vitesse     > symétrique
!                                   1 = en incrémental > non-symétrique
!                   crit(3) = valeur de la tolérance de convergence (resi_inte_rela == rescrel)
!                   crit(5) = nombre d'incréments pour le redécoupage local du pas de temps
!                             (iter_inte_pas == itedec)
!                                   0 = pas de redécoupage
!                                   n = nombre de paliers
!   angmas      les trois angles du mot-clef massif venant de AFFE_CARA_ELEM
!                   un réel qui vaut 0 si nautiques ou 2 si Euler
!                   les angles soit nautiques soit Euler

!   icomp       compteur de redécoupage produit par redece
!   nvi         nombre de variables internes du point d'intégration
!   instam      instant t-
!   instap      instant t+
!   deps        incrément de déformation totale
!   sigm        contrainte  à t-
!   epsm        déformation à t-
!   vim         variables internes a t-
!                   attention "vim" variables internes a t- modifiées si redécoupage local
!   option      option de calcul
!                   'rigi_meca_tang'> dsidep(t)
!                   'full_meca'     > dsidep(t+dt) , sig(t+dt)
!                   'raph_meca'     > sig(t+dt)
!
! OUT
!   sigp        contrainte a t+
!   vip         variables internes a t+
!   dsidep      matrice de comportement tangent
!   codret      code retour
!                   0   Tout va bien
!                   1   Redécoupage global ?
!                   2   Redécoupage local  ?
! --------------------------------------------------------------------------------------------------
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/nmcine.h"
#include "asterfort/nmcine_line_gc.h"
#include "asterfort/nmecmi.h"
#include "asterfort/utmess.h"
!
    integer             :: kpg, ksp, ndim, imate
    integer             :: icomp, nvi
    integer             :: codret
    character(len=8)    :: typmod(*)
    character(len=16)   :: compor(*), option
    character(len=*)    :: fami
!
    real(kind=8)        :: angmas(*)
    real(kind=8)        :: crit(*), instam, instap
    real(kind=8)        :: epsm(6), deps(6)
    real(kind=8)        :: sigm(6), vim(*), sigp(6), vip(*), dsidep(6, 6)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=32)   :: messk(3)
    logical             :: iscplane
!
! --------------------------------------------------------------------------------------------------
!
    if (compor(1)(1:14) .eq. 'VMIS_CINE_LINE') then
!
        iscplane = typmod(1)(1:6).eq.'C_PLAN'
        if ( iscplane) then
            call nmcine_line_gc(fami,   kpg,    ksp,    ndim, typmod, &
                                imate,  compor, crit,   epsm, deps,   &
                                sigm,   vim,    option, sigp, vip,    &
                                dsidep, codret)
        else
            call nmcine(fami,   kpg,    ksp,    ndim,  imate, &
                        compor, crit,   instam, instap, epsm, &
                        deps,   sigm,   vim,    option, sigp, &
                        vip,    dsidep, codret)
        endif
!
    else if (compor(1)(1:12) .eq. 'VMIS_CINE_GC') then
!
        iscplane = typmod(1)(1:6).eq.'C_PLAN'
        if ( .not. iscplane) then
            messk(1) = compor(1)
            messk(2) = 'C_PLAN, 1D, GRILLE_EXCENTRE'
            messk(3) = typmod(1)
            call utmess('F', 'ALGORITH4_1', nk=3, valk=messk)
        endif
        call nmcine_line_gc(fami,   kpg,    ksp,    ndim, typmod, &
                            imate,  compor, crit,   epsm, deps,   &
                            sigm,   vim,    option, sigp, vip,    &
                            dsidep, codret)
!
    else if (compor(1)(1:9).eq.'VMIS_ECMI') then
!
        call nmecmi(fami,   kpg,    ksp,  ndim, typmod, &
                    imate,  compor, crit, deps, sigm,   &
                    vim,    option, sigp, vip,  dsidep, &
                    codret)
!
    endif
!
end subroutine
