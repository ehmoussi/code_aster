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

subroutine surfc1(sdcont, unit_msg)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfdisl.h"
#include "asterfort/cfdisr.h"
#include "asterfort/mminfl.h"
#include "asterfort/mminfr.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: sdcont
    integer, intent(in) :: unit_msg
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Print debug for discrete formulation
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  unit_msg         : logical unit for messages (print)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_cont_zone
    integer :: i_zone
    character(len=24) :: sdcont_defi
    aster_logical :: l_veri, l_cont_gcp, l_gliss
    integer :: stop_singular, nb_resol, gcp_maxi, gcp_precond, gcp_rech_line
    real(kind=8) :: tole_interp, gcp_resi, gcp_coef_resi, glis_alarm
    real(kind=8) :: coef_pena_cont, coef_pena_frot, coef_frot, coef_matr_frot
!
! --------------------------------------------------------------------------------------------------
!
    sdcont_defi = sdcont(1:8)//'.CONTACT'
!
! - Parameters
!
    nb_cont_zone  = cfdisi(sdcont_defi,'NZOCO')
    stop_singular = cfdisi(sdcont_defi,'STOP_SINGULIER')
    nb_resol      = cfdisi(sdcont_defi,'NB_RESOL')
    l_cont_gcp    = cfdisl(sdcont_defi,'CONT_GCP' )
    gcp_resi      = cfdisr(sdcont_defi,'RESI_ABSO')
    gcp_maxi      = cfdisi(sdcont_defi,'ITER_GCP_MAXI')
    gcp_precond   = cfdisi(sdcont_defi,'PRE_COND')
    gcp_coef_resi = cfdisr(sdcont_defi,'COEF_RESI')
    gcp_rech_line = cfdisi(sdcont_defi,'RECH_LINEAIRE')
    l_gliss       = cfdisl(sdcont_defi,'CONT_DISC_GLIS')
    glis_alarm    = cfdisr(sdcont_defi,'ALARME_JEU')
!
! - User print
!
    write (unit_msg,*)
    write (unit_msg,*) '<CONTACT> INFOS SPECIFIQUES SUR LA FORMULATION DISCRETE'
    write (unit_msg,*)
!
! - Print constant parameters
!
    write (unit_msg,*) '<CONTACT> ... PARAMETRES CONSTANTS SUR TOUTES LES ZONES'
    write (unit_msg,170) 'STOP_SINGULIER  ',stop_singular
    write (unit_msg,170) 'NB_RESOL        ',nb_resol
    if (l_gliss) then
        write (unit_msg,*) '<CONTACT> ...... GLISSIERE : OUI'
    else
        write (unit_msg,*) '<CONTACT> ...... GLISSIERE : NON'
    endif
    if (l_gliss) then
        write (unit_msg,171) 'ALARME_JEU     ',glis_alarm
    endif
    if (l_cont_gcp) then
        write (unit_msg,170) 'PRE_COND        ',gcp_precond
        write (unit_msg,170) 'RECH_LINEAIRE   ',gcp_rech_line
        write (unit_msg,171) 'RESI_ABSO       ',gcp_resi
        write (unit_msg,170) 'ITER_GCP_MAXI   ',gcp_maxi
        write (unit_msg,171) 'COEF_RESI       ',gcp_coef_resi
    endif
!
! - Print variables parameters
!
    write (unit_msg,*) '<CONTACT> ... PARAMETRES VARIABLES / ZONE'
    do i_zone = 1, nb_cont_zone
        write (unit_msg,*) '<CONTACT> ...... ZONE : ',i_zone
        l_veri = mminfl(sdcont_defi,'VERIF', i_zone)
        if (l_veri) then
            write (unit_msg,*) '<CONTACT> ...... ZONE DE VERIFICATION'
            tole_interp = mminfr(sdcont_defi,'TOLE_INTERP',i_zone)
            write (unit_msg,171) 'TOLE_INTERP     ',tole_interp
        else
            write (unit_msg,*) '<CONTACT> ...... ZONE DE CALCUL'
            coef_pena_cont = mminfr(sdcont_defi,'E_N',i_zone)
            coef_pena_frot = mminfr(sdcont_defi,'E_T',i_zone)
            coef_frot      = mminfr(sdcont_defi,'COEF_COULOMB',i_zone)
            coef_matr_frot = mminfr(sdcont_defi,'COEF_MATR_FROT',i_zone)
            write (unit_msg,171) 'COEF_MATR_FROT  ',coef_matr_frot
            write (unit_msg,171) 'E_N             ',coef_pena_cont
            write (unit_msg,171) 'E_T             ',coef_pena_frot
            write (unit_msg,171) 'COULOMB         ',coef_frot
        endif
    end do
!
170 format (' <CONTACT> ...... PARAM. : ',a16,' - VAL. : ',i5)
171 format (' <CONTACT> ...... PARAM. : ',a16,' - VAL. : ',e12.5)
!
end subroutine
